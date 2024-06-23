package;

import flixel.FlxGame;
import openfl.display.Sprite;
import sys.io.File;
import sys.FileSystem;
import states.PlayState;
import states.SayoriQuickEndState;

class Main extends Sprite
{
    var config = {
        width: 1280, // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
        height: 720, // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
        zoom: -1.0, // If -1, zoom is automatically calculated to fit the window dimensions. (Removed from Flixel 5.0.0)
        framerate: 60, // How many frames per second the game should run at.
        skipSplash: false, // Whether to skip the flixel splash screen that appears in release mode.
        startFullscreen: false // Whether to start the game in fullscreen on desktop targets'
    };

    public function new()
    {
        super();
        
        var initialState:Class<flixel.FlxState> = if (checkFiles()) PlayState else SayoriQuickEndState;

        addChild(new FlxGame(config.width, config.height, initialState, 
            #if (flixel < "5.0.0") config.zoom, #end 
            config.framerate, config.framerate, config.skipSplash, config.startFullscreen));
    }

    private function checkFiles():Bool
    {
        var monikaExists = FileSystem.exists("assets/characters/monika.chr");
        var sayoriExists = FileSystem.exists("assets/characters/sayori.chr");
        var charsexist:Bool = true;
        
        if (!monikaExists) {
            trace("monika.chr is missing!");
           // Credits: https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
           deleteDirRecursively("assets/characters");
           trace("deleted characters folder lol!");
           charsexist = false;

        }

        if (!sayoriExists) {
            trace("sayori.chr is missing!");
            charsexist = true;
        }

        if (!charsexist)
        {
            Sys.exit(1);
            trace("The game can't run without monika and sayori lol!");
        }    

        return monikaExists && sayoriExists;
    }

    // Credits: https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
    private function deleteDirRecursively(path:String) : Void
    {
    if (sys.FileSystem.exists(path) && sys.FileSystem.isDirectory(path))
    {
        var entries = sys.FileSystem.readDirectory(path);
        for (entry in entries) {
        if (sys.FileSystem.isDirectory(path + '/' + entry)) {
            deleteDirRecursively(path + '/' + entry);
            sys.FileSystem.deleteDirectory(path + '/' + entry);
        } else {
            sys.FileSystem.deleteFile(path + '/' + entry);
        }
        }
    }
    }
}
