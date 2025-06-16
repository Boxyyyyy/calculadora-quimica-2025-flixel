package;

import flixel.math.FlxMath;

using StringTools;

class Util
{
    private static final tabla_periodica:Map<String, Array<Dynamic>> = [ // Símbolo Químico:String - Nombre Completo:String - Número Átomico:Int - Masa Atómica:Float - Tipo de Elemento:Int
 		'h' => ['H', 'Hidrógeno', 1, 1.008, 0],
        'he' => ['He', 'Helio', 2, 4.002602, 1],
        'li' => ['Li', 'Litio', 3, 6.94, 2],
        'be' => ['Be', 'Berilio', 4, 9.0121831, 9],
        'b' => ['B', 'Boro', 5, 10.81, 3],
        'c' => ['C', 'Carbono', 6, 12.011, 0],
        'n' => ['N', 'Nitrógeno', 7, 14.007, 0],
        'o' => ['O', 'Oxígeno', 8, 15.999, 0],
        'f' => ['F', 'Flúor', 9, 18.99840316, 0],
        'ne' => ['Ne', 'Neón', 10, 20.1797, 1],
        'na' => ['Na', 'Sodio', 11, 22.98976928, 2],
        'mg' => ['Mg', 'Magnesio', 12, 24.305, 9],
        'al' => ['Al', 'Aluminio', 13, 26.9815385, 4],
        'si' => ['Si', 'Silicio', 14, 28.085, 3],
        'p' => ['P', 'Fósforo', 15, 30.97376200, 0],
        's' => ['S', 'Azufre', 16, 32.06, 0],
        'cl' => ['Cl', 'Cloro', 17, 35.45, 0],
        'ar' => ['Ar', 'Argón', 18, 39.948, 1],
        'k' => ['K', 'Potasio', 19, 39.0983, 2],
        'ca' => ['Ca', 'Calcio', 20, 40.078, 9],
        'sc' => ['Sc', 'Escandio', 21, 44.955908, 5],
        'ti' => ['Ti', 'Titanio', 22, 47.867, 5],
        'v' => ['V', 'Vanadio', 23, 50.9415, 5],
        'cr' => ['Cr', 'Cromo', 24, 51.9961, 5],
        'mn' => ['Mn', 'Manganeso', 25, 54.938044, 5],
        'fe' => ['Fe', 'Hierro', 26, 55.845, 5],
        'co' => ['Co', 'Cobalto', 27, 58.933194, 5],
        'ni' => ['Ni', 'Níquel', 28, 58.6934, 5],
        'cu' => ['Cu', 'Cobre', 29, 63.546, 5],
        'zn' => ['Zn', 'Zinc', 30, 65.38, 5],
        'ga' => ['Ga', 'Galio', 31, 69.723, 4],
        'ge' => ['Ge', 'Germanio', 32, 72.630, 3],
        'as' => ['As', 'Arsénico', 33, 74.921595, 3],
        'se' => ['Se', 'Selenio', 34, 78.971, 0],
        'br' => ['Br', 'Bromo', 35, 79.904, 0],
        'kr' => ['Kr', 'Kriptón', 36, 83.798, 1],
        'rb' => ['Rb', 'Rubidio', 37, 85.4678, 2],
        'sr' => ['Sr', 'Estroncio', 38, 87.62, 9],
        'y' => ['Y', 'Itrio', 39, 88.90584, 5],
        'zr' => ['Zr', 'Zirconio', 40, 91.224, 5],
        'nb' => ['Nb', 'Niobio', 41, 92.90637, 5],
        'mo' => ['Mo', 'Molibdeno', 42, 95.96, 5],
        'tc' => ['Tc', 'Tecnecio', 43, 98, 5],
        'ru' => ['Ru', 'Rutenio', 44, 101.07, 5],
        'rh' => ['Rh', 'Rodio', 45, 102.90550, 5],
        'pd' => ['Pd', 'Paladio', 46, 106.42, 5],
        'ag' => ['Ag', 'Plata', 47, 107.8682, 5],
        'cd' => ['Cd', 'Cadmio', 48, 112.414, 5],
        'in' => ['In', 'Indio', 49, 114.818, 4],
        'sn' => ['Sn', 'Estaño', 50, 118.710, 4],
        'sb' => ['Sb', 'Antimonio', 51, 121.760, 3],
        'te' => ['Te', 'Telurio', 52, 127.60, 3],
        'i' => ['I', 'Yodo', 53, 126.90447, 0],
        'xe' => ['Xe', 'Xenón', 54, 131.293, 1],
        'cs' => ['Cs', 'Cesio', 55, 132.90545196, 2],
        'ba' => ['Ba', 'Bario', 56, 137.327, 9],
        'la' => ['La', 'Lantano', 57, 138.90547, 6],
        'ce' => ['Ce', 'Cerio', 58, 140.116, 6],
        'pr' => ['Pr', 'Praseodimio', 59, 140.90766, 6],
        'nd' => ['Nd', 'Neodimio', 60, 144.242, 6],
        'pm' => ['Pm', 'Prometio', 61, 145, 6],
        'sm' => ['Sm', 'Samario', 62, 150.36, 6],
        'eu' => ['Eu', 'Europio', 63, 151.964, 6],
        'gd' => ['Gd', 'Gadolinio', 64, 157.25, 6],
        'tb' => ['Tb', 'Terbio', 65, 158.92535, 6],
        'dy' => ['Dy', 'Disprosio', 66, 162.500, 6],
        'ho' => ['Ho', 'Holmio', 67, 164.93033, 6],
        'er' => ['Er', 'Erbio', 68, 167.259, 6],
        'tm' => ['Tm', 'Tulio', 69, 168.93422, 6],
        'yb' => ['Yb', 'Iterbio', 70, 173.054, 6],
        'lu' => ['Lu', 'Lutecio', 71, 174.9668, 6],
        'hf' => ['Hf', 'Hafnio', 72, 178.49, 5],
        'ta' => ['Ta', 'Tántalo', 73, 180.94788, 5],
        'w' => ['W', 'Wolframio', 74, 183.84, 5],
        're' => ['Re', 'Renio', 75, 186.207, 5],
        'os' => ['Os', 'Osmio', 76, 190.23, 5],
        'ir' => ['Ir', 'Iridio', 77, 192.217, 5],
        'pt' => ['Pt', 'Platino', 78, 195.084, 5],
        'au' => ['Au', 'Oro', 79, 196.966569, 5],
        'hg' => ['Hg', 'Mercurio', 80, 200.592, 5],
        'tl' => ['Tl', 'Talio', 81, 204.38, 4],
        'pb' => ['Pb', 'Plomo', 82, 207.2, 4],
        'bi' => ['Bi', 'Bismuto', 83, 208.98040, 4],
        'po' => ['Po', 'Polonio', 84, 209, 4],
        'at' => ['At', 'Astato', 85, 210, 4],
        'rn' => ['Rn', 'Radón', 86, 222, 1],
        'fr' => ['Fr', 'Francio', 87, 223, 2],
        'ra' => ['Ra', 'Radio', 88, 226, 9],
        'ac' => ['Ac', 'Actinio', 89, 227, 7],
        'th' => ['Th', 'Torio', 90, 232.0377, 7],
        'pa' => ['Pa', 'Protactinio', 91, 231.03588, 7],
        'u' => ['U', 'Uranio', 92, 238.02891, 7],
        'np' => ['Np', 'Neptunio', 93, 237, 7],
        'pu' => ['Pu', 'Plutonio', 94, 244, 7],
        'am' => ['Am', 'Americio', 95, 243, 7],
        'cm' => ['Cm', 'Curio', 96, 247, 7],
        'bk' => ['Bk', 'Berkelio', 97, 247, 7],
        'cf' => ['Cf', 'Californio', 98, 251, 7],
        'es' => ['Es', 'Einstenio', 99, 252, 7],
        'fm' => ['Fm', 'Fermio', 100, 257, 7],
        'md' => ['Md', 'Mendelevio', 101, 258, 7],
        'no' => ['No', 'Nobelio', 102, 259, 7],
        'lr' => ['Lr', 'Lawrencio', 103, 262, 7],
        'rf' => ['Rf', 'Rutherfordio', 104, 267, 5],
        'db' => ['Db', 'Dubnio', 105, 268, 5],
        'sg' => ['Sg', 'Seaborgio', 106, 271, 5],
        'bh' => ['Bh', 'Bohrio', 107, 272, 5],
        'hs' => ['Hs', 'Hasio', 108, 270, 5],
        'mt' => ['Mt', 'Meitnerio', 109, 276, 8],
        'ds' => ['Ds', 'Darmstatio', 110, 281, 8],
        'rg' => ['Rg', 'Roentgenio', 111, 280, 8],
        'cn' => ['Cn', 'Copernicio', 112, 285, 8],
        'nh' => ['Nh', 'Nihonio', 113, 286, 8],
        'fl' => ['Fl', 'Flerovio', 114, 289, 8],
        'mc' => ['Mc', 'Moscovio', 115, 290, 8],
        'lv' => ['Lv', 'Livermorio', 116, 293, 8],
        'ts' => ['Ts', 'Teneso', 117, 294, 8],
        'og' => ['Og', 'Oganesón', 118, 294, 8]
    ];

    private static final subscriptNumbers:Map<String, String> = [ // Número Normal:String - Número chiquito:String
        '0' => '₀',
        '1' => '₁',
        '2' => '₂',
        '3' => '₃',
        '4' => '₄',
        '5' => '₅',
        '6' => '₆',
        '7' => '₇',
        '8' => '₈',
        '9' => '₉'
    ];

	private static final expoNumbers:Map<String, String> = [ // Número Normal:String - Número elevado:String
        '0' => '⁰',
        '1' => '¹',
        '2' => '²',
        '3' => '³',
        '4' => '⁴',
        '5' => '⁵',
        '6' => '⁶',
        '7' => '⁷',
        '8' => '⁸',
        '9' => '⁹'
    ];

	private static final elementsLayout:Array<Array<String>> = [
        ["h", null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, "he"],
        ["li", "be", null, null, null, null, null, null, null, null, null, null, null, "b", "c", "n", "o", "f", "ne"],
        ["na", "mg", null, null, null, null, null, null, null, null, null, null, null, "al", "si", "p", "s", "cl", "ar"],
        ["k", "ca", "sc", null, "ti", "v", "cr", "mn", "fe", "co", "ni", "cu", "zn", "ga", "ge", "as", "se", "br", "kr"],
        ["rb", "sr", "y", null, "zr", "nb", "mo", "tc", "ru", "rh", "pd", "ag", "cd", "in", "sn", "sb", "te", "i", "xe"],
        ["cs", "ba", "la", null, "hf", "ta", "w", "re", "os", "ir", "pt", "au", "hg", "tl", "pb", "bi", "po", "at", "rn"],
        ["fr", "ra", "ac", null, "rf", "db", "sg", "bh", "hs", "mt", "ds", "rg", "cn", "nh", "fl", "mc", "lv", "ts", "og"],
        [],
        [null, null, null, null, "ce", "pr", "nd", "pm", "sm", "eu", "gd", "tb", "dy", "ho", "er", "tm", "yb", "lu"],
        [null, null, null, null, "th", "pa", "u", "np", "pu", "am", "cm", "bk", "cf", "es", "fm", "md", "no", "lr"]
    ];
    
    public static function gcd(a:Float, b:Int):Int
        {
            var absA = Math.abs(a);
            var absB = Math.abs(b);

            while (absB != 0)
            {
                var temp = absB;
                absB = absA % absB;
                absA = temp;
            }

            return Math.round(absA);
        }
    
    public static function lcm(a:Int, b:Int):Int
        {
            if (a == 0 || b == 0) return 0;
                                        
            if (a == 1) return Math.round(Math.abs(b));
            if (b == 1) return Math.round(Math.abs(a));

            return Math.floor(Math.abs(a * b) / gcd(a, b));
        }

    private static function getSimplifiedDenominator(f:Float, maxDenominator:Int = 20):Int
    {
        if (Math.abs(f) < FlxMath.EPSILON) return 1;
        
        if (Math.abs(f - Math.round(f)) < FlxMath.EPSILON) return 1;
        
        for (d in 1...maxDenominator + 1)
        {
            var n_float = f * d;
            
            if (Math.abs(n_float - Math.round(n_float)) < FlxMath.EPSILON * d)
                {
                    var num = Std.int(Math.round(n_float));
                    var den = d;

                    var commonDivisor = gcd(num, den);
                    return Math.floor(den / commonDivisor);
                }
        }

        trace('Warning: Could not find a simple fraction for ${f} with maxDenominator ${maxDenominator}. Treating as whole or using high precision.');

        var highPrecisionFactor = 10000; // e.g., for 0.123 -> 123/1000
        var numHP = Std.int(Math.round(f * highPrecisionFactor));
        var denHP = highPrecisionFactor;
        var commonDivisorHP = gcd(numHP, denHP);

        return Math.floor(denHP / commonDivisorHP);
    }

    public static function normalizarSolucionesAEnteros(soluciones:Array<Float>, ?ignoreZerosInGCD:Bool = true):Array<Int>
        {
            if (soluciones == null || soluciones.length == 0)
                return [];
            
            var allZero = true;

            for (s in soluciones) {
                if (Math.abs(s) > FlxMath.EPSILON) {
                    allZero = false;
                    break;
                }
            }

            if (allZero) {
                var zeroResult:Array<Int> = [];
                for (s in soluciones) zeroResult.push(0);
                return zeroResult;
            }
    
    
            var denominators:Array<Int> = [];

            for (sol in soluciones)
            {
                if (Math.abs(sol) < FlxMath.EPSILON) denominators.push(1);
                else denominators.push(getSimplifiedDenominator(sol));
            }
    
            if (denominators.length == 0) 
                return [];
    
            var overallLcm:Int = 1;

            if (denominators.length > 0) {
                overallLcm = denominators[0];

                if (overallLcm == 0) 
                    overallLcm = 1;

                for (i in 1...denominators.length)
                {
                    var den = denominators[i];

                    if (den == 0) 
                        den = 1;

                    overallLcm = lcm(overallLcm, den);
                }
            }
            
            if (overallLcm == 0) 
                overallLcm = 1;
    
    
            var integerSolutions:Array<Int> = [];

            for (sol in soluciones)
            {
                var scaledValue = sol * overallLcm;
                integerSolutions.push(Std.int(Math.round(scaledValue)));
            }
    
            if (integerSolutions.length > 0)
            {
                var currentGcd:Null<Int> = null;
    
                for(val in integerSolutions) {
                    if (!ignoreZerosInGCD || val != 0) {
                        currentGcd = Math.round(Math.abs(val));
                        break;
                    }
                }
                
                if (currentGcd == null) {
                    // awesomeee
                } else {
                     if (currentGcd == 0 && integerSolutions.filter(v -> v != 0).length > 0) {
                        // Edge case: first non-zero considered was 0, but others exist. Find a non-zero one.
                        // This block might be redundant if the first loop correctly finds a non-zero.
                     }
    
                    for (i in 0...integerSolutions.length)
                    {
                        var val = integerSolutions[i];
                        if (!ignoreZerosInGCD || val != 0) {
                             if (currentGcd == null) currentGcd = Math.round(Math.abs(val));
                             else currentGcd = gcd(currentGcd, Math.round(Math.abs(val)));
                        }
                        

                        if (currentGcd != null && currentGcd == 1) break;
                    }
    
                    if (currentGcd != null && currentGcd > 1)
                    {
                        for (i in 0...integerSolutions.length)
                            integerSolutions[i] = Math.floor(integerSolutions[i] / currentGcd);
                    }
                }
            }
            return integerSolutions;
        }
    
    public static inline function convertToSubscript(number:Null<Int>):String
    {
        if (!Math.isNaN(number) && number != null) {
            var numberString:String = Std.string(number);
          
            var numberArray:Array<String> = numberString.split('');

            var subscriptedNumber:String = '';

            for (num in numberArray) {
                if (subscriptNumbers.exists(num)) subscriptedNumber = subscriptedNumber + subscriptNumbers.get(num);
                else subscriptedNumber = subscriptedNumber + '₊';
            }

			if (number == 1)
				return '';

            return subscriptedNumber;
        }
        return '0';
        
    }

	public static inline function convertToExpo(number:Null<Int>):String
    {
        if (!Math.isNaN(number) && number != null) {
            var numberString:String = Std.string(number);
          
            var numberArray:Array<String> = numberString.split('');

            var subscriptedNumber:String = '';

            for (num in numberArray) {
                if (expoNumbers.exists(num)) subscriptedNumber = subscriptedNumber + expoNumbers.get(num);
                else subscriptedNumber = subscriptedNumber + '⁺';
            }

			switch (number)
			{
				case 0:
					return '?';
				case 1:
					return '';
				default:
					return subscriptedNumber;
			}
        }
        return '0';
        
    }

    public static inline function exactSetGraphicSize(obj:Dynamic, width:Float, height:Float)
    {
        obj.scale.set(Math.abs(((obj.width - width) / obj.width) - 1), Math.abs(((obj.height - height) / obj.height) - 1));
    }
}