package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.Sprite;

#if html5
import js.html.audio.AudioContext;
import js.Browser;
#end

class Main extends Sprite
{
	#if html5
	public static var context:AudioContext;
	#end
	
	public static final game = {
		width: 640,
		height: 480,
		initialState: PlayState,
		zoom: 1.0,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public function new()
	{
		super();

		final calc = new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.skipSplash, game.startFullscreen);

		addChild(calc);

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.sound.soundTrayEnabled = false;

		#if html5
		// Listen for first user interaction
		Browser.document.addEventListener("click", initAudioContext);
		Browser.document.addEventListener("keydown", initAudioContext);
		#end

	}

	#if html5
	private function initAudioContext(_:Dynamic):Void
		{
			if (context == null)
			{
				context = new AudioContext();
				trace("AudioContext initialized!");
	
				// Optional: play 1-frame silent buffer to unlock audio system
				var buffer = context.createBuffer(1, 1, 22050);
				var source = context.createBufferSource();
				source.buffer = buffer;
				source.connect(context.destination);
				source.start(0);
			}
	
			// Remove listeners so it doesn't re-init
			Browser.document.removeEventListener("click", initAudioContext);
			Browser.document.removeEventListener("keydown", initAudioContext);
		}
	#end
}
