package;

import flixel.FlxState;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Util;

class PlayState extends FlxUIState
{
	var inputOutline:FlxSprite;
	var inputInline:FlxSprite;

	var enUnMenu:Bool = false;

	var arrayIndex:Int = 0;

	var ecuacion_reactante:Array<Array<Dynamic>> = [ // HARDCODED EXAMPLE REACTANT SIDE
		['h', 2], ['o', 2]
	];

	var textosLocos:Array<FlxText> = [];

	var ecuacion_producto:Array<Array<Dynamic>> = [ // HARDCODED EXAMPLE PRODUCT SIDE
		[['h', 2], ['o', 1]]
	];

	var elementos_presentes:Array<String> = [];

	var reactanteFullString:String = '';

	var texto_ecuacion:FlxText;

	var elementoInput:FlxUIInputText;

	var agregar_sustanciaBtn:FlxSprite;

	var myVeryBestForever:FlxSprite;
	var menuTab:FlxSprite;
	var reactanteTabButton:FlxSprite;
	var productoTabButton:FlxSprite;

	var menuAH:Array<FlxBasic> = [];

	var curTab:Int = -1;

	var tabs:Array<FlxSprite> = [];

	var menuReactante:Array<FlxBasic> = [];

	var menuProducto:Array<FlxBasic> = [];

	override public function create()
	{
		inputOutline = new FlxSprite().makeGraphic(1, 1, 0xFFFFFFFF);
		inputOutline.scale.set(FlxG.width - 60, FlxG.height / 5);
		inputOutline.updateHitbox();
		inputOutline.setPosition((FlxG.width - inputOutline.width) / 2, 35);

		inputInline = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		inputInline.scale.set(inputOutline.width - 20, inputOutline.height - 20);
		inputInline.updateHitbox();
		inputInline.setPosition(inputOutline.x + (inputOutline.width - inputInline.width) / 2, inputOutline.y + (inputOutline.height - inputInline.height) / 2);

		texto_ecuacion = new FlxText(0, 0, 0, '', 28);

		initEcuacion();
		
		texto_ecuacion.text = reactanteFullString;

		trace(reactanteFullString);

		agregar_sustanciaBtn = new FlxSprite(5, 200).loadGraphic('embed:assets/embed/agregarSustancia.png');
		agregar_sustanciaBtn.scale.set(0.75, 0.75);
		agregar_sustanciaBtn.updateHitbox();

		texto_ecuacion.setFormat('embed:assets/embed/notosans.ttf', 28, 0xFFFFFFFF, CENTER);
		texto_ecuacion.size = Math.round(Math.min(28.0, 28.0 * ((inputInline.width - 10) / texto_ecuacion.width)));
		texto_ecuacion.updateHitbox();
		texto_ecuacion.setPosition(inputInline.x + (inputInline.width - texto_ecuacion.width) / 2, inputInline.y + (inputInline.height - texto_ecuacion.height) / 2);
		texto_ecuacion.textField.antiAliasType = ADVANCED;
		texto_ecuacion.textField.sharpness = 400;

		myVeryBestForever = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		myVeryBestForever.scale.set(FlxG.width, FlxG.height);
		myVeryBestForever.alpha = 0.00001;
		myVeryBestForever.updateHitbox();

		elementoInput = new FlxUIInputText(10, 50, 200, '', 10);
		elementoInput.setFormat('embed:assets/embed/notosans.ttf', 10, 0xFF000000);
		elementoInput.textField.antiAliasType = ADVANCED;
		elementoInput.textField.sharpness = 400;
		menuAH.push(elementoInput);

		menuTab = new FlxSprite().loadGraphic('embed:assets/embed/tabb.png');
		menuTab.scale.set(0.75, 0.75);
		menuTab.updateHitbox();
		menuTab.screenCenter();

		reactanteTabButton = new FlxSprite().loadGraphic('embed:assets/embed/tabLol.png');
		reactanteTabButton.scale.set(0.75, 0.75);
		reactanteTabButton.updateHitbox();
		reactanteTabButton.setPosition(menuTab.x, menuTab.y - reactanteTabButton.height + 7);
		reactanteTabButton.ID = 0;
		menuAH.push(reactanteTabButton);
		tabs.push(reactanteTabButton);

		productoTabButton = new FlxSprite().loadGraphic('embed:assets/embed/tabLol.png');
		productoTabButton.scale.set(0.75, 0.75);
		productoTabButton.updateHitbox();
		productoTabButton.setPosition((menuTab.x + menuTab.width) - productoTabButton.width, reactanteTabButton.y);
		productoTabButton.ID = 1;
		menuAH.push(productoTabButton);
		tabs.push(productoTabButton);

		var textoReactanteTab:FlxText = new FlxText(reactanteTabButton.x - 1, reactanteTabButton.y - 4, reactanteTabButton.width, 'REACTANTE');
		textoReactanteTab.setFormat('embed:assets/embed/notosansthin.ttf', 28, 0xFF000000, CENTER);
		textoReactanteTab.updateHitbox();
		menuAH.push(textoReactanteTab);

		var textoProductoTab:FlxText = new FlxText(productoTabButton.x - 1, productoTabButton.y - 4, productoTabButton.width, 'PRODUCTO');
		textoProductoTab.setFormat('embed:assets/embed/notosansthin.ttf', 28, 0xFF000000, CENTER);
		textoProductoTab.updateHitbox();
		menuAH.push(textoProductoTab);

		var pruebaReactante:FlxText = new FlxText(0, 0, 0, 'reactante', 28);
		pruebaReactante.setFormat('embed:assets/embed/notosans.ttf', 28, 0xFF000000, CENTER);
		pruebaReactante.updateHitbox();
		pruebaReactante.screenCenter();
		menuReactante.push(pruebaReactante);

		var pruebaProducto:FlxText = new FlxText(0, 0, 0, 'producto', 28);
		pruebaProducto.setFormat('embed:assets/embed/notosans.ttf', 28, 0xFF000000, CENTER);
		pruebaProducto.updateHitbox();
		pruebaProducto.screenCenter();
		menuProducto.push(pruebaProducto);

		menuAH.push(menuTab);

		for (i in [inputOutline, inputInline, texto_ecuacion, agregar_sustanciaBtn, myVeryBestForever])
			add(i);

		for (a in menuAH) {
			a.visible = false;
			add(a);
		}

		for (xd in menuReactante) {
			xd.visible = false;
			add(xd);
		}

		for (dx in menuProducto) {
			dx.visible = false;
			add(dx);
		}
	
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// + OPENS EQUATION MENU

		if (agregar_sustanciaBtn != null && !enUnMenu && FlxG.mouse.overlaps(agregar_sustanciaBtn)) {
			agregar_sustanciaBtn.color = 0xFFC6C6C6;
			agregar_sustanciaBtn.scale.set(0.725, 0.725);

			if (FlxG.mouse.justPressed) {
				enUnMenu = true;
				myVeryBestForever.alpha = 0.65;

				for (a in menuAH)
					a.visible = true;

				FlxTween.color(agregar_sustanciaBtn, 0.25, agregar_sustanciaBtn.color, 0xFFFFFFFF, {ease: FlxEase.quadOut});
				FlxTween.tween(agregar_sustanciaBtn.scale, {x: 0.75, y: 0.75}, 0.25, {ease: FlxEase.quadOut});
			}
		} else {
			if (!enUnMenu) {
				agregar_sustanciaBtn.color = 0xFFFFFFFF;
				agregar_sustanciaBtn.scale.set(0.75, 0.75);
			}
		}

		for (boton in tabs) {
			if (boton != null) {
				if (enUnMenu && FlxG.mouse.overlaps(boton)) {

					if (boton.ID != curTab && curTab != -1)
						boton.color = 0xFF7F7F7F;
					else if (boton.ID != curTab && curTab == -1)
						boton.color = 0xFFC1C1C1;
	
					if (FlxG.mouse.justPressed && boton.ID != curTab) {
						curTab = boton.ID;
						boton.color = 0xFFFFFFFF;

						// + CURTAB = 0 IS THE REACTANT SIDE AND CURTAB = 1 IS THE PRODUCT SIDE, CLICKING ON THE TABS SHOWS EITHER EQUATION SIDE AND HAS A UI TO CHANGE THE ELEMENTS INDIVIDUALLY

						// + PREFERABLY USE FLIXEL-UI ELEMENTS TO ACHIEVE THIS

						// + ADD A WAY TO ADD SUBSTANCES TO EACH SIDE AND BE ABLE TO EDIT THEM, BE ABLE TO IMPLEMENT A WAY TO COMMENCE THE STOICHIOMETRY CALCULATION
	
						for (s in menuProducto)
							s.visible = (curTab == 0 ? false : true);
	
						for (a in menuReactante)
							a.visible = (curTab == 0 ? true : false);
					}
				} else {
					if (enUnMenu) {
						if (boton.ID != curTab && curTab != -1)
							boton.color = 0xFFB2B2B2;
						else if (boton.ID != curTab && curTab == -1)
							boton.color = 0xFFFFFFFF;
					}
				}
			}
		}

		/*
			for (a in menuAH)
				a.visible = false;
		*/

		if (FlxG.keys.justPressed.SPACE) {
			for (texto in textosLocos)
				texto.visible = true;
		} else if (FlxG.keys.justPressed.T) {
			for (texto in textosLocos)
				texto.visible = false;
		}
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText) && sender == elementoInput) {
			trace(elementoInput.text);
		}
	}

	function initEcuacion():Void
	{
		reactanteFullString = '';
		arrayIndex = 0;

		for (texto in textosLocos)
			FlxDestroyUtil.destroy(texto);
		
		textosLocos = [];
		elementos_presentes = [];

		var reactanteMoleculas:Map<String, Int> = [];
		var productoMoleculas:Map<String, Int> = [];

		if (ecuacion_reactante.length <= 0) { // + IF THE REACTANT/PRODUCT
			reactanteFullString = '¡Porfavor introducir una ecuación de reactante!';
			return;
		}

		@:privateAccess {
			for (sustancia in ecuacion_reactante) {
				if (Type.getClass(sustancia[0]) == Array) {
					var sustanciaEpica:Array<Dynamic> = sustancia;

					// trace(sustancia);
	
					for (elemento in sustanciaEpica) {
						var cantidadMolecula:Null<Int> = 1;
						var cantidadMoleculaString:String = '';

						if (elemento.length > 0)
							cantidadMolecula = elemento[1];

						if (Util.tabla_periodica.exists(elemento[0])) {
							cantidadMoleculaString = Util.convertToSubscript(elemento[1]);

							if (cantidadMolecula == 1)
								cantidadMoleculaString = '';

							reactanteFullString = reactanteFullString + Util.tabla_periodica.get(elemento[0])[0] + cantidadMoleculaString;

							if (!reactanteMoleculas.exists(elemento[0])) {
								reactanteMoleculas.set(elemento[0], cantidadMolecula);

								if (!elementos_presentes.contains(elemento[0]))
									elementos_presentes.push(elemento[0]);
							} else {
								var lolael:Int = reactanteMoleculas.get(elemento[0]);

								reactanteMoleculas.set(elemento[0], cantidadMolecula + lolael);
							}
							
						} else {
							trace('buuuu');
							trace(elemento[0]);
						}
					}
				} else {
					var cantidadMolecula:Null<Int> = 1;
					var cantidadMoleculaString:String = '';

					if (sustancia.length > 0)
						cantidadMolecula = sustancia[1];

					if (Util.tabla_periodica.exists(sustancia[0])) {
						cantidadMoleculaString = Util.convertToSubscript(sustancia[1]);

						if (cantidadMolecula == 1)
							cantidadMoleculaString = '';

						reactanteFullString = reactanteFullString + Util.tabla_periodica.get(sustancia[0])[0] + cantidadMoleculaString;

						if (!reactanteMoleculas.exists(sustancia[0])) {
							reactanteMoleculas.set(sustancia[0], cantidadMolecula);

							if (!elementos_presentes.contains(sustancia[0]))
								elementos_presentes.push(sustancia[0]);
						} else {
							var lolael:Int = reactanteMoleculas.get(sustancia[0]);

							reactanteMoleculas.set(sustancia[0], cantidadMolecula + lolael);
						}
					}
				}

				// trace(reactanteFullString);
	
				if (ecuacion_reactante[arrayIndex + 1] != null)
					reactanteFullString = reactanteFullString + ' + ';
				else {
					reactanteFullString = reactanteFullString + ' -> ';
					break;
				}
				
				arrayIndex += 1;
			}

			arrayIndex = 0;

			for (sustancia in ecuacion_producto) {
				if (Type.getClass(sustancia[0]) == Array) {
					var sustanciaEpica:Array<Dynamic> = sustancia;

					// trace(sustancia);
	
					for (elemento in sustanciaEpica) {
						var cantidadMolecula:Null<Int> = 1;
						var cantidadMoleculaString:String = '';

						if (elemento.length > 0)
							cantidadMolecula = elemento[1];

						if (Util.tabla_periodica.exists(elemento[0])) {
							cantidadMoleculaString = Util.convertToSubscript(elemento[1]);

							if (cantidadMolecula == 1)
								cantidadMoleculaString = '';

							reactanteFullString = reactanteFullString + Util.tabla_periodica.get(elemento[0])[0] + cantidadMoleculaString;

							if (!productoMoleculas.exists(elemento[0]))
								productoMoleculas.set(elemento[0], cantidadMolecula);
							else {
								var lolael:Int = productoMoleculas.get(elemento[0]);
	
								productoMoleculas.set(elemento[0], cantidadMolecula + lolael);
							}
						} else {
							trace('buuuu');
							trace(elemento[0]);
						}
					}
				} else {
					var cantidadMolecula:Null<Int> = 1;
					var cantidadMoleculaString:String = '';

					if (sustancia.length > 0)
						cantidadMolecula = sustancia[1];

					if (Util.tabla_periodica.exists(sustancia[0])) {
						cantidadMoleculaString = Util.convertToSubscript(sustancia[1]);

						if (cantidadMolecula == 1)
							cantidadMoleculaString = '';

						reactanteFullString = reactanteFullString + Util.tabla_periodica.get(sustancia[0])[0] + cantidadMoleculaString;

						if (!productoMoleculas.exists(sustancia[0]))
							productoMoleculas.set(sustancia[0], cantidadMolecula);
						else {
							var lolael:Int = productoMoleculas.get(sustancia[0]);

							productoMoleculas.set(sustancia[0], cantidadMolecula + lolael);
						}
					}
				}
	
				if (ecuacion_producto[arrayIndex + 1] != null)
					reactanteFullString = reactanteFullString + ' + ';

				arrayIndex += 1;
			}

			var okLol:FlxText = new FlxText(texto_ecuacion.x, inputOutline.y + inputOutline.height + 25, '-- MOLÉCULAS REACTANTE --');
			okLol.setFormat('embed:assets/embed/notosans.ttf', 14, 0xFFFFFFFF, FlxTextAlign.CENTER);
			okLol.updateHitbox();
			okLol.screenCenter(X);
			add(okLol);

			// Para los reactantes

			for (i in 0...elementos_presentes.length) {
				var textitoLoco:FlxText = new FlxText(okLol.x, okLol.y + ((okLol.height + 10) * (i + 1)), '${Util.tabla_periodica.get(elementos_presentes[i])[1]}: ${reactanteMoleculas.get(elementos_presentes[i])}'); 
				textitoLoco.setFormat('embed:assets/embed/notosans.ttf', 14, 0xFFFFFFFF, FlxTextAlign.CENTER);
				textitoLoco.updateHitbox();
				textosLocos.push(textitoLoco);
				add(textitoLoco);
			}

			var okLolAgain:FlxText = new FlxText(okLol.x, textosLocos[textosLocos.length - 1].y + textosLocos[textosLocos.length - 1].height + 10, '-- MOLÉCULAS PRODUCTO --');
			okLolAgain.setFormat('embed:assets/embed/notosans.ttf', 14, 0xFFFFFFFF, FlxTextAlign.CENTER);
			okLolAgain.updateHitbox();
			add(okLolAgain);

			// Para el producto

			for (i in 0...elementos_presentes.length) {
				var textitoLoco:FlxText = new FlxText(okLol.x, okLolAgain.y + ((okLolAgain.height + 10) * (i + 1)), '${Util.tabla_periodica.get(elementos_presentes[i])[1]}: ${productoMoleculas.get(elementos_presentes[i])}'); 
				textitoLoco.setFormat('embed:assets/embed/notosans.ttf', 14, 0xFFFFFFFF, FlxTextAlign.CENTER);
				textitoLoco.updateHitbox();
				textosLocos.push(textitoLoco);
				add(textitoLoco);
			}

			trace(reactanteMoleculas);
			trace(productoMoleculas);
		}

		for (texto in textosLocos)
			texto.visible = false;
	}
}