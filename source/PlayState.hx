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
import flixel.group.FlxSpriteContainer;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;

import linahx.Matrix;

import Util;

class PlayState extends FlxUIState
{
	var enUnMenu:Bool = false;
	var curMenu:String = '';
	
	var arrayIndex:Int = 0;

	var ecuacion_reactante:Array<Array<Dynamic>> = [ // HARDCODED EXAMPLE REACTANT SIDE
		[['h', 2], ['s', 1], ['o', 4]],
		[['ca', 3], ['p', 2], ['o', 8]],
	];

	/*
		[['h', 2], ['s', 1], ['o', 4]],
		[['ca', 3], ['p', 2], ['o', 8]],
	*/

	var textosLocos:Array<FlxText> = [];

	var ecuacion_producto:Array<Array<Dynamic>> = [ // HARDCODED EXAMPLE PRODUCT SIDE
		[['ca', 1], ['s', 1], ['o', 4]],
		[['h', 3], ['p', 1], ['o', 4]]
	];

	/*
		[['ca', 1], ['s', 1], ['o', 4]],
		[['h', 3], ['p', 1], ['o', 4]]
	*/

	var ecuacionFinal:Array<Array<Dynamic>> = [];

	// DEBUG

	var elementos_presentes:Array<String> = [];

	var elementosEcuacion:Array<Array<Float>> = [];

	var siEstaBalanceado:Bool = true;
	var isDraggingScrollBar:Bool = false;

	var reactanteFullString:String = '';

	var texto_ecuacion:FlxText;
	var texto_ecuacion_tab:FlxText;

	var agregar_sustanciaBtn:FlxSprite;
	var sustancia_rect:FlxRect;

	var myVeryBestForever:FlxSprite;
	var menuTab:FlxSprite;
	var reactanteTabButton:FlxSprite;
	var productoTabButton:FlxSprite;
	var elCubitoLoco:FlxSprite;

	var ecuacionProductoEquilibrio:FlxText;
	var ecuacionReactanteEquilibrio:FlxText;

	var scrollBar:FlxSprite;
	var curScrollPos:Array<Float> = [0, 0]; // REACTANTE - PRODUCTO
	var scrollWheel:Float;
	var pDeltaY:Float;

	var menuAH:Array<FlxBasic> = [];

	var curTab:Int = -1;

	var curSustanciaLo:Int = -1;

	var menuReactante:Array<FlxBasic> = [];
	var menuProducto:Array<FlxBasic> = [];

	var reactanteSpriteGroup:FlxTypedGroup<SustanciaMenu>;
	var productoSpriteGroup:FlxTypedGroup<SustanciaMenu>;

	var reactanteMoleculas:Map<String, Int> = [];
	var productoMoleculas:Map<String, Int> = []; 

	var solucionesChiChegnol:Array<Int> = [];

	var editarReactanteBoton:FlxSprite;
	var editarProductoBoton:FlxSprite;
	var closeMenu:FlxSprite;

	var cameraLo:FlxCamera = null;

	override public function create()
	{
		var cameraInit = new FlxCamera();
		cameraInit.bgColor = 0xFFFFFFFF;
		FlxG.cameras.add(cameraInit);

		reactanteSpriteGroup = new FlxTypedGroup<SustanciaMenu>();
		productoSpriteGroup = new FlxTypedGroup<SustanciaMenu>();

		var fraccionLinea:FlxSprite = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		fraccionLinea.scale.set(250, 5);
		fraccionLinea.updateHitbox();
		fraccionLinea.setPosition((FlxG.width - fraccionLinea.width) / 2, (FlxG.height - fraccionLinea.height) / 2);

		ecuacionProductoEquilibrio = new FlxText(0, 0, 0, '[C]').setFormat('embed:assets/embed/notosans.ttf', 42, 0xFF000000, CENTER);
		ecuacionReactanteEquilibrio = new FlxText(0, 0, 0, '[A] * [B]³').setFormat('embed:assets/embed/notosans.ttf', 42, 0xFF000000, CENTER);

		for (a in [fraccionLinea, ecuacionProductoEquilibrio, ecuacionReactanteEquilibrio])
			add(a);

		var editarProductoBoton_Base:FlxSprite = new FlxSprite().makeGraphic(185, 45, 0x00000000);
		editarProductoBoton_Base.updateHitbox();
		editarProductoBoton_Base.setPosition(fraccionLinea.x + ((fraccionLinea.width - editarProductoBoton_Base.width) / 2), fraccionLinea.y - editarProductoBoton_Base.height - 65);

		editarProductoBoton = FlxSpriteUtil.drawRoundRect(editarProductoBoton_Base, 0, 0, 185, 45, 15, 15, 0xFFFFFFFF, {
				thickness: 3.5,
				color: FlxColor.BLACK
			});

		var displayEditarProductoText:FlxText = new FlxText(0, 0, editarProductoBoton_Base.width, 'EDITAR PRODUCTO(s)').setFormat('embed:assets/embed/notosans.ttf', 16, 0xFF000000, CENTER);
		displayEditarProductoText.setPosition(editarProductoBoton_Base.x, editarProductoBoton_Base.y + ((editarProductoBoton_Base.height - displayEditarProductoText.height) / 2));

		for (p in [editarProductoBoton_Base, editarProductoBoton, displayEditarProductoText])
			add(p);

		var editarReactanteBoton_Base:FlxSprite = new FlxSprite().makeGraphic(185, 45, 0x00000000);
		editarReactanteBoton_Base.updateHitbox();
		editarReactanteBoton_Base.setPosition(fraccionLinea.x + ((fraccionLinea.width - editarReactanteBoton_Base.width) / 2), (fraccionLinea.y + editarReactanteBoton_Base.height) + 25);

		editarReactanteBoton = FlxSpriteUtil.drawRoundRect(editarReactanteBoton_Base, 0, 0, 185, 45, 15, 15, 0xFFFFFFFF, {
				thickness: 3.5,
				color: FlxColor.BLACK
			});

		var displayEditarReactanteText:FlxText = new FlxText(0, 0, editarReactanteBoton_Base.width, 'EDITAR REACTANTE(s)').setFormat('embed:assets/embed/notosans.ttf', 16, 0xFF000000, CENTER);
		displayEditarReactanteText.setPosition(editarReactanteBoton_Base.x, editarReactanteBoton_Base.y + ((editarReactanteBoton_Base.height - displayEditarReactanteText.height) / 2));

		for (r in [editarReactanteBoton_Base, editarReactanteBoton, displayEditarReactanteText])
			add(r);

		var closeMenu_base:FlxSprite = new FlxSprite().makeGraphic(50, 50, 0x00000000);
		closeMenu_base.updateHitbox();

		texto_ecuacion = new FlxText(0, 0, 0, '(Ecuación Química)', 28);

		menuTab = new FlxSprite().loadGraphic('embed:assets/embed/tabb.png');
		menuTab.scale.set(0.75, 0.75);
		menuTab.updateHitbox();
		menuTab.screenCenter();
		menuReactante.push(menuTab);
		menuProducto.push(menuTab);

		elCubitoLoco = new FlxSprite().makeGraphic(1, 1, 0xFFB7B7B7);
		elCubitoLoco.scale.set(menuTab.width - 80, 175);
		elCubitoLoco.updateHitbox();
		elCubitoLoco.setPosition((FlxG.width - elCubitoLoco.width) / 2, ((menuTab.height - elCubitoLoco.height) / 2) + 120);
		menuReactante.push(elCubitoLoco);
		menuProducto.push(elCubitoLoco);

		cameraLo = new FlxCamera(Math.round(elCubitoLoco.x), Math.round(elCubitoLoco.y), Math.round(elCubitoLoco.width), Math.round(elCubitoLoco.height) - 1);
		cameraLo.bgColor.alpha = 0;
		FlxG.cameras.add(cameraLo, false);
		cameraLo.visible = false;

		reactanteSpriteGroup.cameras = [cameraLo];
		productoSpriteGroup.cameras = [cameraLo];

		menuReactante.push(reactanteSpriteGroup);
		menuProducto.push(productoSpriteGroup);

		initEcuacion();
		
		texto_ecuacion.text += '\n$reactanteFullString';

		agregar_sustanciaBtn = new FlxSprite(-905, 200).loadGraphic('embed:assets/embed/agregarSustancia.png');
		agregar_sustanciaBtn.scale.set(0.75, 0.75);
		agregar_sustanciaBtn.updateHitbox();
	
		ecuacionReactanteEquilibrio.size = Math.round(Math.min(42.0, 42.0 * ((fraccionLinea.width - 10) / ecuacionReactanteEquilibrio.width)));
		ecuacionReactanteEquilibrio.updateHitbox();
		ecuacionReactanteEquilibrio.setPosition(fraccionLinea.x + ((fraccionLinea.width - ecuacionReactanteEquilibrio.width) / 2), (fraccionLinea.y + fraccionLinea.height) + 2.5);

		ecuacionProductoEquilibrio.size = Math.round(Math.min(42.0, 42.0 * ((fraccionLinea.width - 10) / ecuacionProductoEquilibrio.width)));
		ecuacionProductoEquilibrio.updateHitbox();
		ecuacionProductoEquilibrio.setPosition(fraccionLinea.x + ((fraccionLinea.width - ecuacionProductoEquilibrio.width) / 2), fraccionLinea.y - ecuacionProductoEquilibrio.height - 2.5);

		texto_ecuacion.setFormat('embed:assets/embed/notosans.ttf', 18, 0xFF7C7C7C, CENTER);
		texto_ecuacion.updateHitbox();
		texto_ecuacion.setPosition((FlxG.width - texto_ecuacion.width) / 2, 0 + texto_ecuacion.height - 10);
		texto_ecuacion.textField.antiAliasType = ADVANCED;
		texto_ecuacion.textField.sharpness = 400;

		myVeryBestForever = new FlxSprite().makeGraphic(1, 1, 0xFF000000);
		myVeryBestForever.scale.set(FlxG.width * 2, FlxG.height * 2);
		myVeryBestForever.alpha = 0.00001;
		myVeryBestForever.updateHitbox();

		closeMenu_base.setPosition((menuTab.x + menuTab.width) - (closeMenu_base.width + 10), menuTab.y + 10);

		closeMenu = FlxSpriteUtil.drawRoundRect(closeMenu_base, 0, 0, 50, 50, 15, 15 , 0xFFFFFFFF, {
				thickness: 1.25,
				color: FlxColor.BLACK
			});

		closeMenu.color = 0xFFFF5B5B;

		var displayCloseMenuText:FlxText = new FlxText(0, 0, closeMenu_base.width, 'X').setFormat('embed:assets/embed/notosans.ttf', 36, 0xFF000000, CENTER);
		displayCloseMenuText.setPosition(closeMenu_base.x, closeMenu_base.y + ((closeMenu_base.height - displayCloseMenuText.height) / 2));
		displayCloseMenuText.bold = true;

		var tituloTabReactante:FlxText = new FlxText(186, 91, 0, 'Ecuación Reactante:', 28);
		tituloTabReactante.setFormat('embed:assets/embed/notosans.ttf', 28, 0xFF000000, CENTER);
		tituloTabReactante.updateHitbox();
		menuReactante.push(tituloTabReactante);

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

		for (i in [texto_ecuacion, myVeryBestForever])
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

		for (c in [closeMenu_base, closeMenu, displayCloseMenuText]) {
			c.visible = false;
			menuProducto.push(c);
			menuReactante.push(c);
			add(c);
		}

		myVeryBestForever.alpha = 0.65;

		var elementTiles:FlxTypedGroup<ElementTile>;

		var epicAmazing:FlxSprite = new FlxSprite().loadGraphic('embed:assets/embed/tabb.png');
		epicAmazing.scale.set(0.85, 0.875);
		epicAmazing.updateHitbox();
		epicAmazing.setPosition((FlxG.width - epicAmazing.width) / 2, ((FlxG.height - epicAmazing.height) / 2) + 8);
		add(epicAmazing);

		elementTiles = new FlxTypedGroup<ElementTile>();
        add(elementTiles);

        var TILE_WIDTH:Float = 22;
        var TILE_HEIGHT:Float = 22;
        var TILE_SPACING:Float = 4;

		@:privateAccess {
			for (row in 0...Util.elementsLayout.length)
			{
				for (col in 0...Util.elementsLayout[row].length)
				{
					var elementSymbol = Util.elementsLayout[row][col];
					if (elementSymbol != null && elementSymbol.indexOf("-") == -1) // Ignore nulls and range placeholders
					{
						var tileX = 75 + ((TILE_WIDTH + TILE_SPACING) * col);
						// Adjust position for Lanthanides and Actinides to be separate
						var tileY = 180 + ((row >= 8) 
							? (TILE_HEIGHT + TILE_SPACING) * (row - 2 + 1.5) // Position them below the main table with a gap
							: (TILE_HEIGHT + TILE_SPACING) * row);

						var tile = new ElementTile(tileX, tileY, TILE_WIDTH, TILE_HEIGHT, elementSymbol);
						elementTiles.add(tile);
					}
				}
			}
		}

		curMenu = 'H3PO4 REACTANTE PERIODIC';
		enUnMenu = true;
	
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (editarProductoBoton != null && !enUnMenu && FlxG.mouse.overlaps(editarProductoBoton) && curMenu != 'producto') {
			editarProductoBoton.color = 0xFFC6C6C6;
			editarProductoBoton.scale.set(0.975, 0.975);

			if (FlxG.mouse.justPressed) {
				curTab = 1;
				enUnMenu = true;
				editarProductoBoton.color = 0xFFA3A3A3;
				curMenu = 'producto';
				myVeryBestForever.alpha = 0.65;
				cameraLo.visible = true;

				texto_ecuacion_tab.text = cargar_string_ecuacion(curTab);
				texto_ecuacion_tab.size = Math.round(Math.min(36.0, 36.0 * ((menuTab.width - 20) / texto_ecuacion_tab.width)));
				texto_ecuacion_tab.screenCenter(X);

				for (a in menuProducto)
					a.visible = true;

				FlxTween.color(editarProductoBoton, 0.25, editarProductoBoton.color, 0xFFFFFFFF, {ease: FlxEase.quadOut});
				FlxTween.tween(editarProductoBoton.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.quadOut});
			}
		} else {
			if (!enUnMenu) {
				editarProductoBoton.color = 0xFFFFFFFF;
				editarProductoBoton.scale.set(1, 1);
			}
		}

		if (editarReactanteBoton != null && !enUnMenu && FlxG.mouse.overlaps(editarReactanteBoton) && curMenu != 'reactante') {
			editarReactanteBoton.color = 0xFFC6C6C6;
			editarReactanteBoton.scale.set(0.975, 0.975);

			if (FlxG.mouse.justPressed) {
				curTab = 0;
				enUnMenu = true;
				editarReactanteBoton.color = 0xFFA3A3A3;
				curMenu = 'reactante';
				myVeryBestForever.alpha = 0.65;
				cameraLo.visible = true;

				texto_ecuacion_tab.text = cargar_string_ecuacion(curTab);
				texto_ecuacion_tab.size = Math.round(Math.min(36.0, 36.0 * ((menuTab.width - 20) / texto_ecuacion_tab.width)));
				texto_ecuacion_tab.screenCenter(X);

				for (a in menuReactante)
					a.visible = true;

				FlxTween.color(editarReactanteBoton, 0.25, editarReactanteBoton.color, 0xFFFFFFFF, {ease: FlxEase.quadOut});
				FlxTween.tween(editarReactanteBoton.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.quadOut});
			}
		} else {
			if (!enUnMenu) {
				editarReactanteBoton.color = 0xFFFFFFFF;
				editarReactanteBoton.scale.set(1, 1);
			}
		}

		if (closeMenu != null && enUnMenu && FlxG.mouse.overlaps(closeMenu) && curMenu != '') {
			closeMenu.color = 0xFFD64D4D;
			closeMenu.scale.set(0.975, 0.975);

			if (FlxG.mouse.justPressed) {
				curTab = -1;
				enUnMenu = false;
				closeMenu.color = 0xFFFF5B5B;
				closeMenu.scale.set(1, 1);
				myVeryBestForever.alpha = 0.0001;
				cameraLo.visible = false;

				switch (curMenu) {
					case 'reactante' | 'producto':
						for (a in menuReactante)
							a.visible = false;

						for (a in menuProducto)
							a.visible = false;
				}

				curMenu = '';
			}
		} else {
			if (enUnMenu) {
				closeMenu.color = 0xFFFF5B5B;
				closeMenu.scale.set(1, 1);
			}
		}

		// MENU REACTANTE/PRODUCTO

		if (reactanteSpriteGroup.members.length > 0) {
			for (elemeneneenenenenenenene in reactanteSpriteGroup.members) {
				if (elemeneneenenenenenenene.base_editarBoton != null && curMenu == 'reactante') {
					if (FlxG.mouse.overlaps(elemeneneenenenenenenene.base_editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo != elemeneneenenenenenenene.ID)
						curSustanciaLo = elemeneneenenenenenenene.ID;
					else if (FlxG.mouse.overlaps(elemeneneenenenenenenene.base_editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo == elemeneneenenenenenenene.ID) {
						reactanteSpriteGroup.members[curSustanciaLo].changeEditButtonColor(0xFF9B9B9B);

						if (FlxG.mouse.justPressed) {
							trace('oaa');
							reactanteSpriteGroup.members[curSustanciaLo].changeEditButtonColor(0xFF686868);
						}
					}
					else if (!FlxG.mouse.overlaps(reactanteSpriteGroup.members[elemeneneenenenenenenene.ID].base_editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo == elemeneneenenenenenenene.ID) {
						reactanteSpriteGroup.members[elemeneneenenenenenenene.ID].changeEditButtonColor();
						curSustanciaLo = -1;
					}
				}
			}
		}

		if (productoSpriteGroup.members.length > 0) {
			for (elemeneneenenenenenenene in productoSpriteGroup.members) {
				if (elemeneneenenenenenenene.base_editarBoton != null && curMenu == 'producto') {
					if (FlxG.mouse.overlaps(elemeneneenenenenenenene.base_editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo != elemeneneenenenenenenene.ID)
						curSustanciaLo = elemeneneenenenenenenene.ID;
					else if (FlxG.mouse.overlaps(elemeneneenenenenenenene.base_editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo == elemeneneenenenenenenene.ID) {
						productoSpriteGroup.members[curSustanciaLo].changeEditButtonColor(0xFF9B9B9B);

						if (FlxG.mouse.justPressed) {
							trace('oaaadas');
							productoSpriteGroup.members[curSustanciaLo].changeEditButtonColor(0xFF686868);
						}
					}
					else if (!FlxG.mouse.overlaps(productoSpriteGroup.members[elemeneneenenenenenenene.ID].base_editarBoton, (cameraLo != null ? cameraLo : null)) && curSustanciaLo == elemeneneenenenenenenene.ID) {
						productoSpriteGroup.members[elemeneneenenenenenenene.ID].changeEditButtonColor();
						curSustanciaLo = -1;
					}
				}
			}
		}

		// SCROLL BAR

		if (curMenu == 'reactante' || curMenu == 'producto')
		{
			var maxScrollY:Float = Math.max(0, elCubitoLoco.height);

			var scrollTrackHeight:Float = elCubitoLoco.height;
			var scrollHandleHeight:Float = scrollBar.height;
			var maxHandleY:Float = elCubitoLoco.y + scrollTrackHeight - scrollHandleHeight;

			if (!isDraggingScrollBar && FlxG.mouse.justPressed && FlxG.mouse.overlaps(scrollBar))
				isDraggingScrollBar = true;

			if (isDraggingScrollBar && FlxG.mouse.justReleased)
				isDraggingScrollBar = false;

			if (isDraggingScrollBar)
				scrollBar.y += FlxG.mouse.deltaY;

			if (FlxG.mouse.wheel != 0 && maxHandleY <= maxScrollY)
				cameraLo.scroll.y -= FlxG.mouse.wheel / 10;

			scrollBar.y = FlxMath.bound(scrollBar.y, elCubitoLoco.y, maxHandleY);

			if (isDraggingScrollBar) {
				var scrollPercent:Float = (scrollBar.y - elCubitoLoco.y) / (scrollTrackHeight - scrollHandleHeight);
				if (Math.isNaN(scrollPercent)) scrollPercent = 0;
				cameraLo.scroll.y = scrollPercent * maxScrollY;
			} else {
				cameraLo.scroll.y = FlxMath.bound(cameraLo.scroll.y, 0, maxScrollY);

				var cameraPercent:Float = cameraLo.scroll.y / maxScrollY;
				if (Math.isNaN(cameraPercent)) cameraPercent = 0;
				scrollBar.y = elCubitoLoco.y + (cameraPercent * (scrollTrackHeight - scrollHandleHeight));
			}
		}
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

				solucionesChiChegnol = Util.normalizarSolucionesAEnteros(soluciones);

				trace('Las soluciones sin amplificar son: ${soluciones}');
				trace('Soluciones: ${solucionesChiChegnol}');

				trace(matrizAumentada);

				// */
			}
		}
	}

	/*
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText) && sender == elementoInput) {
			trace(elementoInput.text);
		}
	}*/

	function initEquilibriumEcuacion():Void
	{
		ecuacionReactanteEquilibrio.text = '';
		ecuacionProductoEquilibrio.text = '';
		arrayIndex = 0;

		var nones:Array<Bool> = [false, false];

		if (ecuacion_reactante.length <= 0)
			ecuacionReactanteEquilibrio.text = 'LA ECUACIÓN NECESITA REACTANTES';

		if (ecuacion_producto.length <= 0)
			ecuacionProductoEquilibrio.text = 'LA ECUACIÓN NECESITA PRODUCTOS';

		@:privateAccess {
			if (ecuacion_reactante.length > 0) {
				for (s in 0...ecuacion_reactante.length) {
					if (ecuacion_reactante[s][0] != null) {
						if (Type.getClass(ecuacion_reactante[s][0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = ecuacion_reactante[s];

							var ecuacionLocaString:String = '[';
						
							for (p in 0...sustanciaEpica.length)
								ecuacionLocaString += '${Util.tabla_periodica.get(sustanciaEpica[p][0])[0]}${Util.convertToSubscript(sustanciaEpica[p][1])}';

							ecuacionLocaString += ']${Util.convertToExpo(solucionesChiChegnol[s])}';

							ecuacionReactanteEquilibrio.text += ecuacionLocaString;
						} else
							ecuacionReactanteEquilibrio.text += '[${Util.tabla_periodica.get(ecuacion_reactante[s][0])[0]}${Util.convertToSubscript(ecuacion_reactante[s][1])}]${Util.convertToExpo(solucionesChiChegnol[s])}';
					}

					if (ecuacion_reactante[arrayIndex + 1] != null) ecuacionReactanteEquilibrio.text += ' • ';
					else break;

					arrayIndex += 1;
				}
			}

			arrayIndex = 0;

			if (ecuacion_producto.length > 0) {
				for (s in 0...ecuacion_producto.length) {
					if (ecuacion_producto[s][0] != null) {
						if (Type.getClass(ecuacion_producto[s][0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = ecuacion_producto[s];

							var ecuacionLocaString:String = '[';
						
							for (p in 0...sustanciaEpica.length)
								ecuacionLocaString += '${Util.tabla_periodica.get(sustanciaEpica[p][0])[0]}${Util.convertToSubscript(sustanciaEpica[p][1])}';

							ecuacionLocaString += ']${Util.convertToExpo(solucionesChiChegnol[s + ecuacion_reactante.length])}';

							ecuacionProductoEquilibrio.text += ecuacionLocaString;
						} else
							ecuacionProductoEquilibrio.text += '[${Util.tabla_periodica.get(ecuacion_producto[s][0])[0]}${Util.convertToSubscript(ecuacion_producto[s][1])}]${Util.convertToExpo(solucionesChiChegnol[s + ecuacion_reactante.length])}';
					}

					if (ecuacion_producto[arrayIndex + 1] != null) ecuacionProductoEquilibrio.text += ' • ';
					else break;

					arrayIndex += 1;
				}
			}

			arrayIndex = 0;
		}
	}

	function reloadEcuacionSustanciaMenu(menuMimic:FlxSprite=null, cam:FlxCamera=null):Void
	{
		var widthLol:Float = (menuMimic != null ? menuMimic.width : 0);

		reactanteSpriteGroup.clear();
		productoSpriteGroup.clear();

		for (i in 0...ecuacion_reactante.length) {
			var reactante_sustancia:SustanciaMenu = new SustanciaMenu(0, 0 + (70 * i), Math.round(elCubitoLoco.width - 20), ecuacion_reactante[i], i, 0, cam);
			reactanteSpriteGroup.add(reactante_sustancia);
			reactante_sustancia.ID = i;

			trace(i);
		}

		for (i in 0...ecuacion_producto.length) {
			var producto_sustancia:SustanciaMenu = new SustanciaMenu(0, 0 + (70 * i), Math.round(elCubitoLoco.width - 20), ecuacion_producto[i], i, 1, cam);
			productoSpriteGroup.add(producto_sustancia);
			producto_sustancia.ID = i;

			trace(i);
		}
	}

	function initEcuacion():Void
	{
		reactanteFullString = '';
		arrayIndex = 0;

		reactanteMoleculas.clear();
		productoMoleculas.clear();

		/*for (texto in textosLocos)
			FlxDestroyUtil.destroy(texto);
		
		textosLocos = [];*/
		elementos_presentes = [];

		@:privateAccess {
			if (ecuacion_reactante.length > 0) {
				for (sustanciaLol in ecuacion_reactante) {
					if (sustanciaLol[0] != null) {

						ecuacionFinal.push(sustanciaLol);

						if (Type.getClass(sustanciaLol[0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = sustanciaLol;

							for (ele in sustanciaEpica)
								setMoleculas(ele[0], ele[1], 0);
						} else
							setMoleculas(sustanciaLol[0], sustanciaLol[1], 0);
					}

					if (ecuacion_reactante[arrayIndex + 1] == null) break;

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
						
							for (ele in sustanciaEpica)
								setMoleculas(ele[0], ele[1], 1);
						} else
							setMoleculas(sustanciaLol[0], sustanciaLol[1], 1);
					}

					if (ecuacion_producto[arrayIndex + 1] == null) break;

					arrayIndex += 1;
				}
			}

			balancear();
			construirEcuacionString();
			initEquilibriumEcuacion();
			
			if (elCubitoLoco != null && cameraLo != null)
				reloadEcuacionSustanciaMenu(elCubitoLoco, cameraLo);

			trace(reactanteFullString);

			/*var okLol:FlxText = new FlxText(texto_ecuacion.x, inputOutline.y + inputOutline.height + 25, '-- MOLÉCULAS REACTANTE --');
			okLol.setFormat('embed:assets/embed/notosans.ttf', 14, 0xFFFFFFFF, FlxTextAlign.CENTER);
			okLol.updateHitbox();
			okLol.screenCenter(X);
			add(okLol);

			// Para los reactantes

			/*for (i in 0...elementos_presentes.length) {
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

			for (texto in textosLocos)
				texto.visible = false;*/

			trace(reactanteMoleculas);
			trace(productoMoleculas);
		}
	}

	function construirEcuacionString():Void
	{
		arrayIndex = 0;

		if (ecuacion_reactante.length <= 0) { // + IF THE REACTANT/PRODUCT
			reactanteFullString = '¡Porfavor introducir una ecuación de reactante!';
			return;
		}
		
		@:privateAccess {
			if (ecuacion_reactante.length > 0) {
				for (s in 0...ecuacion_reactante.length) {
					if (ecuacion_reactante[s][0] != null) {
						if (Type.getClass(ecuacion_reactante[s][0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = ecuacion_reactante[s];

							for (p in 0...sustanciaEpica.length)
								reactanteFullString += '${(p == 0 ? (solucionesChiChegnol[s] == 1 ? '' : Std.string(solucionesChiChegnol[s])) : '')}${Util.tabla_periodica.get(sustanciaEpica[p][0])[0]}${Util.convertToSubscript(sustanciaEpica[p][1])}';
						} else
							reactanteFullString += '${(solucionesChiChegnol[s] == 1 ? '' : Std.string(solucionesChiChegnol[s]))}${Util.tabla_periodica.get(ecuacion_reactante[s][0])[0]}${Util.convertToSubscript(ecuacion_reactante[s][1])}';
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
				for (s in 0...ecuacion_producto.length) {
					if (ecuacion_producto[s][0] != null) {
						if (Type.getClass(ecuacion_producto[s][0]) == Array) {
							var sustanciaEpica:Array<Dynamic> = ecuacion_producto[s];
						
							for (p in 0...sustanciaEpica.length)
								reactanteFullString += '${(p == 0 ? (solucionesChiChegnol[s + ecuacion_reactante.length] == 1 ? '' : Std.string(solucionesChiChegnol[s + ecuacion_reactante.length])) : '')}${Util.tabla_periodica.get(sustanciaEpica[p][0])[0]}${Util.convertToSubscript(sustanciaEpica[p][1])}';
						} else
							reactanteFullString += '${(solucionesChiChegnol[s + ecuacion_reactante.length] == 1 ? '' : Std.string(solucionesChiChegnol[s + ecuacion_reactante.length]))}${Util.tabla_periodica.get(ecuacion_producto[s][0])[0]}${Util.convertToSubscript(ecuacion_producto[s][1])}';
					}

					
					if (ecuacion_producto[arrayIndex + 1] != null) reactanteFullString += ' + ';
					else break;

					arrayIndex += 1;
				}
			}
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
	public var base_editarBoton:FlxSprite;
	var editarLocos:FlxSprite;
	var intCam:FlxCamera = null;

	var intPosLol:Array<Float> = [0, 0];

	// var parent:FlxSprite;

	public var SUSTANCIA_ID:String = '';

	var eso_si_que_no_me_lo_esperaba:Float = 0;

	public function new(?x:Float=0, y:Float, width:Int, sustancia:Array<Dynamic>, id:Int=1, coefVal:Float=1, ladoEcuacion:Int=0, zaCam:FlxCamera=null)
	{
		/*if (parent == null)
			return;

		this.parent = parent;

		trace(parent);*/

		intPosLol = [x, y];

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

		base_editarBoton = new FlxSprite(235, 10 - intPosLol[1]).makeGraphic(100, 50, 0x00000000);

		this.editarLocos = FlxSpriteUtil.drawRoundRect(this.base_editarBoton, 0, 0, 100, 50, 15, 15, 0xFFFFFFFF, {
				thickness: 3.5,
				color: FlxColor.BLACK
			});

		changeEditButtonColor();

		var editarText:FlxText = new FlxText(233.5, 17.5, 100, 'EDITAR').setFormat('embed:assets/embed/notosans.ttf', 24, 0xFF000000, CENTER);

		for (obj in [base, sustancia_id_text, sustancia_texto, mm_display, mm, mm_gmol, base_editarBoton, editarLocos, editarText])
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
		this.editarLocos.color = newColor;
		/*if (this.base_editarBoton != null) {
			this.editarLocos = FlxSpriteUtil.drawRoundRect(this.base_editarBoton, 0, 0, 100, 50, 15, 15, newColor, {
				thickness: 3.5,
				color: FlxColor.BLACK
			});
		}*/
	}

	/*
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (base_editarBoton != null && FlxG.mouse.overlaps(base_editarBoton, (intCam != null ? intCam : null))) {
			changeEditButtonColor(0xFF9B9B9B);

			if (FlxG.mouse.justPressed) {
				changeEditButtonColor(0xFF686868);
			}
		} else if (base_editarBoton != null && !FlxG.mouse.overlaps(base_editarBoton, (intCam != null ? intCam : null))) {
			changeEditButtonColor();
		}
	}*/
}

/**
 * Represents a single, interactive tile on the periodic table.
 */
class ElementTile extends FlxSpriteGroup
{
    public var symbol:String;
    public var background:FlxSprite;
    private var defaultColor:FlxColor;

    public function new(x:Float = 0, y:Float = 0, width:Float, height:Float, elementSymbol:String)
    {
        super(x, y);

		@:privateAccess {
			this.symbol = Util.tabla_periodica.get(elementSymbol)[0];

			switch (Util.tabla_periodica.get(elementSymbol)[4])
			{
				case 0: defaultColor = 0xFF6BA6FF; // No Metales
				case 1: defaultColor = 0xFFFF93AE; // Gases Nobles
				case 2: defaultColor = 0xFF6BE3FF; // Metales Alcalinos
				case 3: defaultColor = 0xFFFFC054; // Metaloides
				case 4: defaultColor = 0xFF9EFFEB; // Metales de Post-Transición
				case 5: defaultColor = 0xFFAA99FF; // Metales de Transición
				case 6: defaultColor = 0xFF00A1FF; // Lantánidos
				case 7: defaultColor = 0xFFFF9C6B; // Actínidos
				case 8: defaultColor = 0xFFB8BBC6; // Otros
				case 9: defaultColor = 0xFFFF4F75; // Alcalinotérreos
				default: defaultColor = 0xFFB8BBC6;
			}
		}

        background = new FlxSprite().makeGraphic(Math.round(width), Math.round(height), defaultColor);
        add(background);

        var symbolText = new FlxText(0, 0, width, this.symbol);
        symbolText.setFormat('embed:assets/embed/notosans.ttf', 11, FlxColor.BLACK, CENTER);
        symbolText.y = (height - symbolText.height) / 2;
        add(symbolText);
    }

	/*
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // --- Hover and Interaction Logic ---
        if (FlxG.mouse.overlaps(this))
        {
            this.scale.set(1.1, 1.1);
            
            if (FlxG.mouse.justPressed)
            {
                trace('Clicked on element: ${this.symbol}');
            }
        }
        else
        {
            this.scale.set(1, 1);
        }
    }*/
}
