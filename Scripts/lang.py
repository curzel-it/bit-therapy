import json
import os

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

def login():
    creds = None
    
    if os.path.exists('token.json'):
        scopes = ['https://www.googleapis.com/auth/spreadsheets.readonly']
        creds = Credentials.from_authorized_user_file('token.json', scopes)
    
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file('credentials.json', scopes)
            creds = flow.run_local_server(port=0)
    
        with open('token.json', 'w') as token:
            token.write(creds.to_json())
    return creds

def translations_spreadsheet_id():
    f = open("config.json")
    d = json.loads(f.read())
    f.close()
    return d["translations_spreadsheet_id"]

def translations_sheet(creds):
    try:
        spreadsheet_id = translations_spreadsheet_id()
        range = "Translations!A1:Z1000"
        service = build('sheets', 'v4', credentials=creds)
        sheet = service.spreadsheets()
        result = sheet.values().get(spreadsheetId=spreadsheet_id, range=range).execute()
        values = result.get('values', [])
        return values
    except Exception as e: 
        print(e)
        return None

def generate_translations_for_all_languages(data):
    for index, lang in enumerate(data[0][1:]):
        generate_translations(data, lang, index+1)
    os.system("rm -rf ../Resources/*.lproj")
    os.system("cp -r generated/translations/* ../Resources")

def generate_translations(data, lang, index):
    translations = [localizable_line(line[0], line[index]) for line in data[1:]]
    translations = '\n'.join(translations)
    path = f'generated/translations/{lang.lower()}.lproj'
    write_to_file(path, 'Localizable.strings', translations)

def write_to_file(filepath, filename, contents):
    if not os.path.exists(filepath): 
        os.makedirs(filepath)
    f = open(os.path.join(filepath, filename), 'w')
    f.write(contents)
    f.close()

def localizable_line(key, value):
    return f'"{key}" = "{value}";'

def generate_swift_source(data):
    keys = [l[0] for l in data[1:]]
    sections = grouped_keys_by_section(keys)
    
    code = '\n\n'.join([swift_source_for_section(name, sections[name]) for name in sections.keys()])

    header = """import Foundation
import Schwifty
import Yage

enum Lang {"""

    footer = """}

extension Lang {
    static func name(forMenuItem item: String) -> String {
        "menu.\(item)".localized()
    }
    
    static func name(forTag tag: String) -> String {
        "tag.\(tag)".localized(or: tag)
    }
}

extension Species {
    var name: String {
        let fallback = id.replacingOccurrences(of: "_", with: " ").capitalized
        return "species.name.\(id)".localized(or: fallback)
    }

    var about: String {
        "species.about.\(id)".localized(or: Lang.CustomPets.customPetDescription)
    }
}"""
    code = '\n'.join([header, code, footer])

    write_to_file('generated', 'Lang.swift', code)
    os.system('swiftformat generated/Lang.swift')
    os.system("cp generated/Lang.swift ../Sources/Models/Lang.swift")

def grouped_keys_by_section(keys):
    sections = [section_name(key) for key in keys]
    sections = sorted(list(set(sections)))
    sections = {section: [] for section in sections}
    
    for key in keys:
        section = section_name(key)
        sections[section].append(key)
    sections.pop('species', None)
    sections.pop('menu', None)
    return sections

def section_name(key): 
    if '.' not in key: return ''
    return key.split('.')[0]

def swift_source_for_section(name, values): 
    code = ''
    name = name.capitalize()
    if name == 'Petselection': name = 'PetSelection'
    if name == 'Custompets': name = 'CustomPets'
    if name != '': code += f'enum {name} ' + '{\n'
    code += '\n'.join([swift_source(key) for key in values])
    if name != '': code += '\n}'
    return code

def swift_source(key):
    name = key.split(".")[-1]
    return f'static let {name} = "{key}".localized()'

def main():
    creds = login()
    if creds is None: 
        print("Could not login")
        return
    
    data = translations_sheet(creds)
    if data is None:  
        print("No data could be found")
        return

    generate_translations_for_all_languages(data)
    generate_swift_source(data)

if __name__ == '__main__':
    main()
