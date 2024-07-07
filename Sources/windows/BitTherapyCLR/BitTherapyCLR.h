#pragma once

#include "../BitTherapyCLR/src/game/game.h"
#include "../BitTherapyCLR/src/pets/pets.h"
#include "../BitTherapyCLR/src/species/species.h"
#include "../BitTherapyCLR/src/sprites/sprites.h"
#include <iostream>
#include <map>
#include <optional>
#include <string>
#include <vector>
#include <msclr/marshal_cppstd.h>
#include <msclr/marshal.h>

using namespace System;
using namespace System::Collections::Generic;

namespace BitTherapyCLR {

    public ref class Utils {
    public:
        static std::vector<std::string> toVector(List<String^>^ list) {
            msclr::interop::marshal_context context;
            std::vector<std::string> vec;
            for each (String ^ str in list) {
                vec.push_back(context.marshal_as<std::string>(str));
            }
            return vec;
        }
    };

    public ref struct MRenderedItem {
    private:

    public:
        uint32_t id;
        double x, y, w, h;
        bool isFlipped;
        double zRotation;
        String^ spritePath;

        MRenderedItem(RenderedItem item) :
            id(item.id),
            x(item.frame.x), y(item.frame.y), w(item.frame.w), h(item.frame.h),
            isFlipped(item.isFlipped),
            zRotation(item.zRotation),
            spritePath(gcnew String(item.spritePath.c_str()))
        {};
    };

    public ref struct ManagedSpecies {
    private:

    public:
        String^ id;
        String^ spritePath;

        ManagedSpecies(std::string speciesId, std::string spritePath) :
            id(gcnew String(speciesId.c_str())),
            spritePath(gcnew String(spritePath.c_str()))
        {};
    };

    public ref class ManagedGame {
    private:
        Game* game;
        SpriteSetBuilder* spriteSetBuilder = new SpriteSetBuilder();
        SpritesRepository* spritesRepo = new SpritesRepository(spriteSetBuilder);
        SpeciesParser* speciesParser = new SpeciesParser();
        SpeciesRepository* speciesRepo = new SpeciesRepository(speciesParser);
        PetsBuilder* petsBuilder;

    public:
        const double x, y, w, h;

        ManagedGame(
            String^ screenName,
            double x, double y, double w, double h,
            double scaleMultiplier, double speedMultiplier,
            double animationFps, double baseEntitySize,
            List<String^>^ speciesPaths,
            List<String^>^ assetsPaths
        ) : x(x), y(y), w(w), h(h) {
            msclr::interop::marshal_context context;

            game = new Game(
                context.marshal_as<std::string>(screenName),
                Rect({ x, y, w, h })
            );

            petsBuilder = new PetsBuilder(
                speciesRepo, spritesRepo,
                animationFps, baseEntitySize,
                scaleMultiplier, speedMultiplier
            );
            speciesRepo->setup(Utils::toVector(speciesPaths));
            spritesRepo->setup(Utils::toVector(assetsPaths));
        }

        ~ManagedGame() {
            this->!ManagedGame();
        }

        !ManagedGame() {
            delete game;
        }

        void Update(TimeSpan timeSinceLastUpdate) {
            auto milliseconds = std::chrono::milliseconds(static_cast<long long>(timeSinceLastUpdate.TotalMilliseconds));
            game->update(milliseconds);
        }

        List<MRenderedItem^>^ Render() {
            std::vector<RenderedItem> renderedItems = game->render();
            List<MRenderedItem^>^ managedRenderedItems = gcnew List<MRenderedItem^>(renderedItems.size());

            for (const RenderedItem& item : renderedItems) {
                MRenderedItem^ managedItem = gcnew MRenderedItem(item);
                managedRenderedItems->Add(managedItem);
            }
            return managedRenderedItems;
        }

        List<ManagedSpecies^>^ AvailableSpecies() {
            std::vector<std::string> species = speciesRepo->availableSpecies();
            List<ManagedSpecies^>^ managedSpeciesList = gcnew List<ManagedSpecies^>(species.size());

            for (const std::string& speciesId : species) {
                auto species = speciesRepo->species(speciesId);
                auto spriteSet = spritesRepo->sprites(speciesId);

                if (species.has_value() && spriteSet.has_value()) {
                    auto frontSprite = spriteSet.value()->spriteFrames("front")[0];
                    ManagedSpecies^ managedSpec = gcnew ManagedSpecies(speciesId, frontSprite);
                    managedSpeciesList->Add(managedSpec);
                }
            }
            return managedSpeciesList;
        }

        void AddEntity(String^ species) {
            msclr::interop::marshal_context context;
            std::string speciesId = context.marshal_as<std::string>(species);
            auto entity = petsBuilder->build(speciesId, game->bounds);
            if (entity.has_value()) {
                game->addEntity(entity.value());
            }
            else {
                std::cout << "Could not add entity of species `" << speciesId << "`" << std::endl;
            }
        }

        void MouseDragStarted(uint32_t targetId) {
            game->mouseDragStarted(targetId);
        }

        void MouseDragEnded(uint32_t targetId, double deltaX, double deltaY) {
            game->mouseDragEnded(targetId, Vector2d({ deltaX, deltaY }));
        }

        String^ ScreenName() {
            return gcnew String(game->screenName.c_str());
        }

        String^ Description() {
            std::string desc = game->description();
            return gcnew String(desc.c_str());
        }
    };
}