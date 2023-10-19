import subprocess
import sys

def package_app(debug):
    spec = 'debug.spec' if debug else 'release.spec'
    command = ['pyinstaller', spec]
    completed_process = subprocess.run(command)
    if completed_process.returncode != 0:
        message = f"Build failed! {completed_process.returncode}"
        raise ChildProcessError(message)

package_app('debug' in sys.argv)
