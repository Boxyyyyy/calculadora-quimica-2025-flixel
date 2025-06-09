package;

import flixel.FlxState;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;

import linahx.Matrix;

import Util;

class PlayState extends FlxUIState
{
	var inputOutline:FlxSprite;
	var inputInline:FlxSprite;

	var enUnMenu:Bool = false;
	var curMenu:String = '';

	var arrayIndex:Int = 0;

	var ecuacion_reactante:Array<Array<Dynamic>> = [ // HARDCODED EXAMPLE REACTANT SIDE
		[['h', 2], ['s', 1], ['o', 4]],
		[['ca', 3], ['p', 2], ['o', 8]],
	];

	var textosLocos:Array<FlxText> = [];

	var ecuacion_producto:Array<Array<Dynamic>> = [ // HARDCODED EXAMPLE PRODUCT SIDE
		[['ca', 1], ['s', 1], ['o', 4]],
		[['h', 3], ['p', 1], ['o', 4]]
	];

	var ecuacionFinal:Array<Array<Dynamic>> = [];

	// DEBUG

	var elementos_presentes:Array<String> = [];

	var elementosEcuacion:Array<Array<Float>> = [];

	var siEstaBalanceado:Bool = true;

	var reactanteFullString:String = '';

	var texto_ecuacion:FlxText;
	var texto_ecuacion_tab:FlxText;

	var elementoInput:FlxUIInputText;

	var agregar_sustanciaBtn:FlxSprite;
	var sustancia_rect:FlxRect;

	var myVeryBestForever:FlxSprite;
	var menuTab:FlxSprite;
	var reactanteTabButton:FlxSprite;
	var productoTabButton:FlxSprite;

	var scrollBar:FlxSprite;
	var curScrollPos:Array<Float> = [0, 0]; // REACTANTE - PRODUCTO
	var scrollWheel:Float;
	var pDeltaY:Float;

	var menuAH:Array<FlxBasic> = [];

	var curTab:Int = -1;

	var curSustanciaLo:Int = -1;

	var tabs:Array<FlxSprite> = [];

	var menuReactante:Array<FlxBasic> = [];
	var menuProducto:Array<FlxBasic> = [];

	var reactanteSpriteGroup:FlxTypedGroup<SustanciaMenu>;

	var reactanteMoleculas:Map<String, Int> = [];
	var productoMoleculas:Map<String, Int> = []; 

	var solucionesChiChegnol:Array<Float> = [];

	var cameraLo:FlxCamera = null;

	override public function create()
	{
		var cameraInit = new FlxCamera();
		FlxG.cameras.add(cameraInit);

		reactanteSpriteGroup = new FlxTypedGroup<SustanciaMenu>();

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

		var tituloTabReactante:FlxText = new FlxText(186, 91, 0, 'Ecuación Reactante:', 28);
		tituloTabReactante.setFormat('embed:assets/embed/notosans.ttf', 28, 0xFF000000, CENTER);
		tituloTabReactante.updateHitbox();
		menuReactante.push(tituloTabReactante);

		var elCubitoLoco:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFFB7B7B7);
		elCubitoLoco.scale.set(menuTab.width - 80, 175);
		elCubitoLoco.updateHitbox();
		elCubitoLoco.setPosition((FlxG.width - elCubitoLoco.width) / 2, ((menuTab.height - elCubitoLoco.height) / 2) + 120);
		menuReactante.push(elCubitoLoco);
		menuProducto.push(elCubitoLoco);

		cameraLo = new FlxCamera(Math.round(elCubitoLoco.x), Math.round(elCubitoLoco.y), Math.round(elCubitoLoco.width), Math.round(elCubitoLoco.height) - 1);
		cameraLo.bgColor.alpha = 0;
		FlxG.cameras.add(cameraLo, false);

		for (i in 0...ecuacion_reactante.length) {
			var reactante_sustancia:SustanciaMenu = new SustanciaMenu(0, 0 + (70 * i), Math.round(elCubitoLoco.width - 20), ecuacion_reactante[i], i, 0, cameraLo);
			reactanteSpriteGroup.add(reactante_sustancia);
			reactante_sustancia.ID = i;

			trace(i);
		}

		reactanteSpriteGroup.cameras = [cameraLo];

		menuReactante.push(reactanteSpriteGroup);

		var scrollingBarSpace:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFF5B5B5B);
		scrollingBarSpace.scale.set(3, elCubitoLoco.height);
		scrollingBarSpace.updateHitbox();
		scrollingBarSpace.setPosition(elCubitoLoco.x + elCubitoLoco.width - 20, elCubitoLoco.y);
		menuReactante.push(scrollingBarSpace);
		menuProducto.push(scrollingBarSpace);

		var myGoat:Int = ((reactanteSpriteGroup.members.length < 3) ? 1 : reactanteSpriteGroup.members.length) - 1;
		var myGoat2:Int = ((reactanteSpriteGroup.members.length < 3) ? 1 : reactanteSpriteGroup.members.length) - 1;

		scrollBar = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		scrollBar.scale.set(20, Math.round(Math.min(elCubitoLoco.height, elCubitoLoco.height - (25 * (curTab == 0 ? myGoat : myGoat2)))));
		scrollBar.updateHitbox();
		scrollBar.setPosition((elCubitoLoco.x + elCubitoLoco.width) - 20, elCubitoLoco.y);
		scrollBar.alpha = 0.65;
		menuReactante.push(scrollBar);
		menuProducto.push(scrollBar);

		var pruebaProducto:FlxText = new FlxText(186, 91, 0, 'Ecuación Producto:', 28);
		pruebaProducto.setFormat('embed:assets/embed/notosans.ttf', 28, 0xFF000000, CENTER);
		pruebaProducto.updateHitbox();
		menuProducto.push(pruebaProducto);

		texto_ecuacion_tab = new FlxText(186, 134, 0, '', 36);
		texto_ecuacion_tab.setFormat('embed:assets/embed/notosans.ttf', 36, 0xFF000000, CENTER);
		texto_ecuacion_tab.updateHitbox();
		texto_ecuacion_tab.screenCenter(X);
		texto_ecuacion_tab.size = Math.round(Math.min(36.0, 36.0 * ((menuTab.width - 20) / texto_ecuacion_tab.width)));
		menuReactante.push(texto_ecuacion_tab);
		menuProducto.push(texto_ecuacion_tab);

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

		if (agregar_sustanciaBtn != null && !enUnMenu && FlxG.mouse.overlaps(agregar_sustanciaBtn) && curMenu != 'main') {
			agregar_sustanciaBtn.color = 0xFFC6C6C6;
			agregar_sustanciaBtn.scale.set(0.725, 0.725);

			if (FlxG.mouse.justPressed) {
				enUnMenu = true;
				curMenu = 'main';
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
				if (enUnMenu && FlxG.mouse.overlaps(boton) && ((curMenu != '' && curMenu != 'menuElemento'))) {

					if (boton.ID != curTab && curTab != -1)
						boton.color = 0xFF7F7F7F;
					else if (boton.ID != curTab && curTab == -1)
						boton.color = 0xFFC1C1C1;
	
					if (FlxG.mouse.justPressed && boton.ID != curTab) {
						curTab = boton.ID;
						boton.color = 0xFFFFFFFF;

						texto_ecuacion_tab.text = cargar_string_ecuacion(curTab);
						texto_ecuacion_tab.screenCenter(X);
						texto_ecuacion_tab.size = Math.round(Math.min(36.0, 36.0 * ((menuTab.width - 20) / texto_ecuacion_tab.width)));
	
						for (s in menuProducto)
							s.visible = (curTab == 0 ? false : true);
	
						for (a in menuReactante)
							a.visible = (curTab == 0 ? true : false);

						curMenu = (curTab == 0 ? 'reactante' : 'producto');

						for (i in menuReactante) {
							if (menuProducto.contains(i))
								i.visible = true;
						}
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

		if (reactanteSpriteGroup.members.length > 0) {
			for (elemeneneenenenenenenene in reactanteSpriteGroup.members) {
				if (elemeneneenenenenenenene.editarBoton != null) {
					if (FlxG.mouse.overlaps(elemeneneenenenenenenene.editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo != elemeneneenenenenenenene.ID) {
						curSustanciaLo = elemeneneenenenenenenene.ID;

						if (curSustanciaLo == elemeneneenenenenenenene.ID) {
							reactanteSpriteGroup.members[curSustanciaLo].changeEditButtonColor(0xFF9B9B9B);

							if (FlxG.mouse.justPressed) {
								reactanteSpriteGroup.members[curSustanciaLo].changeEditButtonColor(0xFF686868);
							}
						}
					} else if (!FlxG.mouse.overlaps(reactanteSpriteGroup.members[elemeneneenenenenenenene.ID].editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo == elemeneneenenenenenenene.ID) {
						reactanteSpriteGroup.members[elemeneneenenenenenenene.ID].changeEditButtonColor();
						curSustanciaLo = -1;
					}
				}
			}
		}

		trace(curSustanciaLo);

		if (FlxG.keys.justPressed.SPACE) {
			for (texto in textosLocos)
				texto.visible = true;
		} else if (FlxG.keys.justPressed.T) {
			for (texto in textosLocos)
				texto.visible = false;
		}
		
		if (FlxG.keys.justPressed.B)
			balancear();

		if (FlxG.keys.justPressed.M && cameraLo?.scroll.y > 0)
			cameraLo.scroll.y -= 5;

		if (FlxG.keys.justPressed.N)
			cameraLo.scroll.y += 5;
	}

	function balancear():Void
	{
		trace(elementos_presentes);

		// conteo de moléculas en un lado

		@:privateAccess {
			for (i in 0...elementos_presentes.length) {
				var moleculaElementoReactante:Int = reactanteMoleculas.get(elementos_presentes[i]);
				var moleculaElementoProducto:Int = productoMoleculas.get(elementos_presentes[i]);

				if (moleculaElementoProducto != moleculaElementoReactante)
					siEstaBalanceado = false;
			}

			if (!siEstaBalanceado) {
				trace('txiuuuu');
				
				for (i in 0...elementos_presentes.length) {
					var arrayLength:Int = ecuacionFinal.length + 1;

					elementosEcuacion.push([]);

					for (placeHolder in 0...arrayLength)
						elementosEcuacion[i].push(0);
					
					for (n in 0...ecuacionFinal.length) {
						if (Type.getClass(ecuacionFinal[n][0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = ecuacionFinal[n];

							for (elemento in sustanciaEpica) {
								if (elemento[0] == elementos_presentes[i])
									elementosEcuacion[i][n] = elemento[1] * ((n < ecuacion_reactante.length) ? 1 : -1);
							}
						} else {
							if (ecuacionFinal[n][0] == elementos_presentes[i])
								elementosEcuacion[i][n] = ecuacionFinal[n][1] * ((n < ecuacion_reactante.length) ? 1 : -1);
						}
					}
				}

				var matrizAumentada:Matrix = Matrix.fromArray2(elementosEcuacion);

				trace(elementosEcuacion);
				trace(matrizAumentada);
				
				///*
				var pivotRow = 0;

				for (pivotCol in 0...matrizAumentada.columns - 1) {
    				if (pivotRow >= matrizAumentada.rows)
						break;

    				var maxRow = pivotRow;

   					for (r in pivotRow + 1...matrizAumentada.rows) {
        				if (Math.abs(matrizAumentada[r][pivotCol]) > Math.abs(matrizAumentada[maxRow][pivotCol]))
            				maxRow = r;
   					}

    				if (Math.abs(matrizAumentada[maxRow][pivotCol]) < FlxMath.EPSILON)
        				continue;

    				if (maxRow != pivotRow) {
						for (c in 0...matrizAumentada.columns) {
							var tempInfo = matrizAumentada[pivotRow][c];

							matrizAumentada[pivotRow][c] = matrizAumentada[maxRow][c];
							matrizAumentada[maxRow][c] = tempInfo;
						}
    				}

				
    		    	var pivotValue = matrizAumentada[pivotRow][pivotCol];

    		    	if (Math.abs(pivotValue) > FlxMath.EPSILON) {
   			    	    for (c in pivotCol...matrizAumentada.columns) 
    		    	        matrizAumentada[pivotRow][c] = matrizAumentada[pivotRow][c] / pivotValue;
    		    	}
				

    				for (r in pivotRow + 1...matrizAumentada.rows) {
        				var factor = matrizAumentada[r][pivotCol];
        	
        				for (c in pivotCol...matrizAumentada.columns) {
							matrizAumentada[r][c] -= factor * matrizAumentada[pivotRow][c];
        				}
   					}
    				
					pivotRow++;
				}

				trace(matrizAumentada);

				var soluciones:Array<Float> = [];

				for (i in 0...matrizAumentada.columns-1) 
					soluciones.push(0);

				var rank = 0;

				for (r_idx in 0...matrizAumentada.rows) {
					var isZeroRow = true;
					for (c_idx in 0...matrizAumentada.columns-1) {
						if (Math.abs(matrizAumentada[r_idx][c_idx]) > FlxMath.EPSILON) {
							isZeroRow = false;
							break;
						}
					}

					if (!isZeroRow)
						rank++;
				}

				if (matrizAumentada.columns-1 > rank) {
					if (matrizAumentada.columns-1 > 0)
						 soluciones[matrizAumentada.columns-2] = 1;
				}

				var r:Int = matrizAumentada.rows-1;
				
				while (r>=0) {
    				var targetPivotCol = -1;

    				for (c in 0...matrizAumentada.columns-1) {
        				if (Math.abs(matrizAumentada[r][c]) > FlxMath.EPSILON) {
							targetPivotCol = c;
							break;
						}
					}

					if (targetPivotCol == -1) {	
						r--;	
						continue;
					}

					var sumOfKnowns:Float = 0;

					for (c in targetPivotCol+1...matrizAumentada.columns-1)
						sumOfKnowns += matrizAumentada[r][c] * soluciones[c];

    				var numerador = matrizAumentada[r][matrizAumentada.columns-1] - sumOfKnowns;
    				var denominador = matrizAumentada[r][targetPivotCol];

					if (Math.abs(denominador) < FlxMath.EPSILON) {
						if (Math.abs(numerador) < FlxMath.EPSILON) trace('Advertencia: El Pivot es cero para una variable básica: ${targetPivotCol}');
						else trace("El sistema no tiene solución o es una contradicción (0 * z = k, k != 0).");
					} else soluciones[targetPivotCol] = numerador / denominador;

					r--;
    			}

				solucionesChiChegnol = soluciones;

				trace('Las soluciones sin amplificar son: ${soluciones}');
				trace('Soluciones: ${Util.normalizarSolucionesAEnteros(soluciones)}');

				trace(matrizAumentada);

				// */
			}
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

		reactanteMoleculas.clear();
		productoMoleculas.clear();

		for (texto in textosLocos)
			FlxDestroyUtil.destroy(texto);
		
		textosLocos = [];
		elementos_presentes = [];

		if (ecuacion_reactante.length <= 0) { // + IF THE REACTANT/PRODUCT
			reactanteFullString = '¡Porfavor introducir una ecuación de reactante!';
			return;
		}

		@:privateAccess {
			if (ecuacion_reactante.length > 0) {
				for (sustanciaLol in ecuacion_reactante) {
					if (sustanciaLol[0] != null) {

						ecuacionFinal.push(sustanciaLol);

						if (Type.getClass(sustanciaLol[0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = sustanciaLol;
						
							for (ele in sustanciaEpica) {
								reactanteFullString += '${Util.tabla_periodica.get(ele[0])[0]}${Util.convertToSubscript(ele[1])}';	
								setMoleculas(ele[0], ele[1], 0);
							}
						} else {
							reactanteFullString += '${Util.tabla_periodica.get(sustanciaLol[0])[0]}${Util.convertToSubscript(sustanciaLol[1])}';
							setMoleculas(sustanciaLol[0], sustanciaLol[1], 0);
						}
					}

					if (ecuacion_reactante[arrayIndex + 1] != null) reactanteFullString += ' + ';
					else {
						reactanteFullString += ' -> ';
						break;
					}

					arrayIndex += 1;
				}
			}

			arrayIndex = 0;

			if (ecuacion_producto.length > 0) {
				for (sustanciaLol in ecuacion_producto) {
					if (sustanciaLol[0] != null) {

						ecuacionFinal.push(sustanciaLol);

						if (Type.getClass(sustanciaLol[0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = sustanciaLol;
						
							for (ele in sustanciaEpica) {
								reactanteFullString += '${Util.tabla_periodica.get(ele[0])[0]}${Util.convertToSubscript(ele[1])}';	
								setMoleculas(ele[0], ele[1], 1);
							}
						} else {
							reactanteFullString += '${Util.tabla_periodica.get(sustanciaLol[0])[0]}${Util.convertToSubscript(sustanciaLol[1])}';
							setMoleculas(sustanciaLol[0], sustanciaLol[1], 1);
						}
					}
						
					if (ecuacion_producto[arrayIndex + 1] != null) reactanteFullString += ' + ';
					else break;

					arrayIndex += 1;
				}
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

			for (texto in textosLocos)
				texto.visible = false;
		}
	}

	function setMoleculas(elemento:String='h', molAm:Int=1, lado:Int=0):Void
	{
		if (lado == 0) {
			if (!reactanteMoleculas.exists(elemento)) {
				reactanteMoleculas.set(elemento, molAm);

				if (!elementos_presentes.contains(elemento))
					elementos_presentes.push(elemento);
			} else {
				var lolael:Int = reactanteMoleculas.get(elemento);

				reactanteMoleculas.set(elemento, molAm + lolael);
			}
		} else {
			if (!productoMoleculas.exists(elemento)) {
				productoMoleculas.set(elemento, molAm);

				if (!elementos_presentes.contains(elemento))
					elementos_presentes.push(elemento);
			} else {
				var lolael:Int = productoMoleculas.get(elemento);

				productoMoleculas.set(elemento, molAm + lolael);
			}
		}
	}

	function cargar_string_ecuacion(lado:Int=0):String
	{
		var laEstring:String = '';
		arrayIndex = 0;

		var epiconium:Array<Array<Dynamic>>;

		epiconium = (lado == 0 ? ecuacion_reactante : ecuacion_producto);

		@:privateAccess {
			if (epiconium.length > 0) {
				for (sustanciaLol in epiconium) {
					if (sustanciaLol[0] != null) {
						if (Type.getClass(sustanciaLol[0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = sustanciaLol;
					
							for (ele in sustanciaEpica)
								laEstring += '${Util.tabla_periodica.get(ele[0])[0]}${Util.convertToSubscript(ele[1])}';		
							
						} else
							laEstring += '${Util.tabla_periodica.get(sustanciaLol[0])[0]}${Util.convertToSubscript(sustanciaLol[1])}';
					}

					if (epiconium[arrayIndex + 1] != null) laEstring = laEstring + ' + ';
					else break;

					arrayIndex += 1;
				}
			}
		}

		return laEstring;
	}
}

class SustanciaMenu extends FlxSpriteGroup
{
	var base:FlxSprite;
	var sustancia_texto:FlxText;
	var sustancia_id_text:FlxText;
	var mm_display:FlxText;
	var mm:FlxText;
	var mm_gmol:FlxText;
	public var editarBoton:FlxSprite;
	var intCam:FlxCamera = null;

	// var parent:FlxSprite;

	public static var SUSTANCIA_ID:String = '';

	var eso_si_que_no_me_lo_esperaba:Float = 0;

	public function new(?x:Float=0, y:Float, width:Int, sustancia:Array<Dynamic>, id:Int=1, coefVal:Float=1, ladoEcuacion:Int=0, zaCam:FlxCamera=null)
	{
		/*if (parent == null)
			return;

		this.parent = parent;

		trace(parent);*/

		if (zaCam!=null)
			intCam = zaCam;

		@:privateAccess {
			if (sustancia.length > 0) {
				for (sustanciaLol in sustancia) {
					if (Type.getClass(sustanciaLol[0]) == Array) {
						var sustanciaEpica:Array<Dynamic> = sustanciaLol[0];
						
						for (ele in sustanciaEpica) {
							SUSTANCIA_ID += '${ele[0]?.toUpperCase()}${(ele[1] == 1 ? '' : ele[1])}';
							eso_si_que_no_me_lo_esperaba += (Util.tabla_periodica.get(ele[0])[3] * ele[1]);
						}
							
					} else {
						SUSTANCIA_ID += '${sustanciaLol[0]?.toUpperCase()}${(sustanciaLol[1] == 1 ? '' : sustanciaLol[1])}';
						eso_si_que_no_me_lo_esperaba += (Util.tabla_periodica.get(sustanciaLol[0])[3] * sustanciaLol[1]);
					}
				}
			}
		}
	
		if (ladoEcuacion == 0)
			SUSTANCIA_ID += ' REACTANTE';
		else
			SUSTANCIA_ID += ' PRODUCTO';

		trace(SUSTANCIA_ID);

		base = new FlxSprite().makeGraphic(1, 1, 0xFF848484);
		base.scale.set(width, 70);
		base.updateHitbox();

		/*
		this.clipRect = FlxRect.get(0, 0, parent.width, parent.height);
		this.clipRect = this.clipRect;

		trace(clipRect);*/

		super(x, y, null);

		sustancia_id_text = new FlxText(2.5, 2.5, 0, 'Sustancia ${id+1}').setFormat('embed:assets/embed/notosans.ttf', 10, 0xFF000000);

		sustancia_texto = new FlxText(15, 15, 0, '').setFormat('embed:assets/embed/notosans.ttf', 30, 0xFF000000);

		@:privateAccess {
			if (sustancia.length > 0) {
				for (sustanciaLol in sustancia) {
					if (sustanciaLol[0] != null) {
						if (Type.getClass(sustanciaLol[0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = sustanciaLol[0];
					
							for (ele in sustanciaEpica)
								sustancia_texto.text += '${Util.tabla_periodica.get(ele[0])[0]}${Util.convertToSubscript(ele[1])}';		
							
						} else
							sustancia_texto.text += '${Util.tabla_periodica.get(sustanciaLol[0])[0]}${Util.convertToSubscript(sustanciaLol[1])}';
					}
				}
			}
		}

		sustancia_texto.size = Math.round(Math.min(30.0, 30.0 * (85 / sustancia_texto.width)));

		mm_display = new FlxText(135, 2.25, 0, 'Masa Molar').setFormat('embed:assets/embed/notosans.ttf', 12, 0xFF000000);

		mm = new FlxText(140, 20, 0, '${FlxMath.roundDecimal(eso_si_que_no_me_lo_esperaba, 2)}').setFormat('embed:assets/embed/notosans.ttf', 16, 0xFF000000, CENTER);
		mm.size = Math.round(Math.min(16.0, 16.0 * (60 / mm.width)));

		mm_gmol = new FlxText(137.5, 17 + mm.height, 0, '(g/mol)').setFormat('embed:assets/embed/notosans.ttf', 16, 0xFF000000, CENTER);

		editarBoton = new FlxSprite(235, 10).makeGraphic(100, 50, 0x00000000);

		changeEditButtonColor();

		var editarText:FlxText = new FlxText(233.5, 17.5, 100, 'EDITAR').setFormat('embed:assets/embed/notosans.ttf', 24, 0xFF000000, CENTER);

		for (obj in [base, sustancia_id_text, sustancia_texto, mm_display, mm, mm_gmol, editarBoton, editarText])
			add(obj);

		this.moves = false;

		/*

		debugBounds = new FlxSprite(bounds.x, bounds.y).makeGraphic(Math.round(bounds.width), Math.round(bounds.height), FlxColor.RED);
		add(debugBounds);		

		trace(clipRect);
		clipRect = localBounds = bounds;
		clipRect = clipRect;
		trace(clipRect);
		//*/
	}

	public function changeEditButtonColor(?newColor:Int=0xFFB7B7B7)
	{
		if (this.editarBoton != null) {
			FlxSpriteUtil.drawRoundRect(this.editarBoton, 0, 0, 100, 50, 15, 15, newColor, {
				thickness: 3.5,
				color: FlxColor.BLACK
			});
		}
	}

	/*override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (editarBoton != null && FlxG.mouse.overlaps(editarBoton, (intCam != null ? intCam : null))) {
			changeEditButtonColor(0xFF9B9B9B);

			if (FlxG.mouse.justPressed) {
				changeEditButtonColor(0xFF686868);
			}
		} else if (editarBoton != null && !FlxG.mouse.overlaps(editarBoton, (intCam != null ? intCam : null))) {
			changeEditButtonColor();
		}
	}	*/
}