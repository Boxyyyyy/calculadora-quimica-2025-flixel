   package;

import flixel.math.FlxMath;

using StringTools;

class Util
{
    private static final tabla_periodica:Map<String, Array<Dynamic>> = [ // Símbolo Químico:String - Nombre Completo:String - Número Átomico:Int - Masa Atómica:Float
        'h' => ['H', 'Hidrógeno', 1, 1.008],
        'he' => ['He', 'Helio', 2, 4.002602],
        'li' => ['Li', 'Litio', 3, 6.94],
        'be' => ['Be', 'Berilio', 4, 9.0121831],
        'b' => ['B', 'Boro', 5, 10.81],
        'c' => ['C', 'Carbono', 6, 12.011],
        'n' => ['N', 'Nitrógeno', 7, 14.007],
        'o' => ['O', 'Oxígeno', 8, 15.999],
        'f' => ['F', 'Flúor', 9, 18.99840316],
        'ne' => ['Ne', 'Neón', 10, 20.1797],
        'na' => ['Na', 'Sodio', 11, 22.98976928],
        'mg' => ['Mg', 'Magnesio', 12, 24.305],
        'al' => ['Al', 'Aluminio', 13, 26.9815385],
        'si' => ['Si', 'Silicio', 14, 28.085],
        'p' => ['P', 'Fósforo', 15, 30.97376200],
        's' => ['S', 'Azufre', 16, 32.06],
        'cl' => ['Cl', 'Cloro', 17, 35.45],
        'ar' => ['Ar', 'Argón', 18, 39.948],
        'k' => ['K', 'Potasio', 19, 39.0983],
        'ca' => ['Ca', 'Calcio', 20, 40.078],
        'sc' => ['Sc', 'Escandio', 21, 44.955908],
        'ti' => ['Ti', 'Titanio', 22, 47.867],
        'v' => ['V', 'Vanadio', 23, 50.9415],
        'cr' => ['Cr', 'Cromo', 24, 51.9961],
        'mn' => ['Mn', 'Manganeso', 25, 54.938044],
        'fe' => ['Fe', 'Hierro', 26, 55.845],
        'co' => ['Co', 'Cobalto', 27, 58.933194],
        'ni' => ['Ni', 'Níquel', 28, 58.6934],
        'cu' => ['Cu', 'Cobre', 29, 63.546],
        'zn' => ['Zn', 'Zinc', 30, 65.38],
        'ga' => ['Ga', 'Galio', 31, 69.723],
        'ge' => ['Ge', 'Germanio', 32, 72.630],
        'as' => ['As', 'Arsénico', 33, 74.921595],
        'se' => ['Se', 'Selenio', 34, 78.971],
        'br' => ['Br', 'Bromo', 35, 79.904],
        'kr' => ['Kr', 'Kriptón', 36, 83.798],
        'rb' => ['Rb', 'Rubidio', 37, 85.4678],
        'sr' => ['Sr', 'Estroncio', 38, 87.62],
        'y' => ['Y', 'Itrio', 39, 88.90584],
        'zr' => ['Zr', 'Zirconio', 40, 91.224],
        'nb' => ['Nb', 'Niobio', 41, 92.90637],
        'mo' => ['Mo', 'Molibdeno', 42, 95.96],
        'tc' => ['Tc', 'Tecnecio', 43, 98],  
        'ru' => ['Ru', 'Rutenio', 44, 101.07],
        'rh' => ['Rh', 'Rodio', 45, 102.90550],
        'pd' => ['Pd', 'Paladio', 46, 106.42],
        'ag' => ['Ag', 'Plata', 47, 107.8682],
        'cd' => ['Cd', 'Cadmio', 48, 112.414],
        'in' => ['In', 'Indio', 49, 114.818],
        'sn' => ['Sn', 'Estaño', 50, 118.710],
        'sb' => ['Sb', 'Antimonio', 51, 121.760],
        'te' => ['Te', 'Telurio', 52, 127.60],
        'i' => ['I', 'Yodo', 53, 126.90447],
        'xe' => ['Xe', 'Xenón', 54, 131.293],
        'cs' => ['Cs', 'Cesio', 55, 132.90545196],
        'ba' => ['Ba', 'Bario', 56, 137.327],
        'la' => ['La', 'Lantano', 57, 138.90547],
        'ce' => ['Ce', 'Cerio', 58, 140.116],
        'pr' => ['Pr', 'Praseodimio', 59, 140.90766],
        'nd' => ['Nd', 'Neodimio', 60, 144.242],
        'pm' => ['Pm', 'Prometio', 61, 145],  
        'sm' => ['Sm', 'Samario', 62, 150.36],
        'eu' => ['Eu', 'Europio', 63, 151.964],
        'gd' => ['Gd', 'Gadolinio', 64, 157.25],
        'tb' => ['Tb', 'Terbio', 65, 158.92535],
        'dy' => ['Dy', 'Disprosio', 66, 162.500],
        'ho' => ['Ho', 'Holmio', 67, 164.93033],
        'er' => ['Er', 'Erbio', 68, 167.259],
        'tm' => ['Tm', 'Tulio', 69, 168.93422],
        'yb' => ['Yb', 'Iterbio', 70, 173.054],
        'lu' => ['Lu', 'Lutecio', 71, 174.9668],
        'hf' => ['Hf', 'Hafnio', 72, 178.49],
        'ta' => ['Ta', 'Tántalo', 73, 180.94788],
        'w' => ['W', 'Wolframio', 74, 183.84],
        're' => ['Re', 'Renio', 75, 186.207],
        'os' => ['Os', 'Osmio', 76, 190.23],
        'ir' => ['Ir', 'Iridio', 77, 192.217],
        'pt' => ['Pt', 'Platino', 78, 195.084],
        'au' => ['Au', 'Oro', 79, 196.966569],
        'hg' => ['Hg', 'Mercurio', 80, 200.592],
        'tl' => ['Tl', 'Talio', 81, 204.38],
        'pb' => ['Pb', 'Plomo', 82, 207.2],
        'bi' => ['Bi', 'Bismuto', 83, 208.98040],
        'po' => ['Po', 'Polonio', 84, 209],  
        'at' => ['At', 'Astato', 85, 210],  
        'rn' => ['Rn', 'Radón', 86, 222],  
        'fr' => ['Fr', 'Francio', 87, 223],  
        'ra' => ['Ra', 'Radio', 88, 226],  
        'ac' => ['Ac', 'Actinio', 89, 227],  
        'th' => ['Th', 'Torio', 90, 232.0377],
        'pa' => ['Pa', 'Protactinio', 91, 231.03588],
        'u' => ['U', 'Uranio', 92, 238.02891],
        'np' => ['Np', 'Neptunio', 93, 237],  
        'pu' => ['Pu', 'Plutonio', 94, 244],  
        'am' => ['Am', 'Americio', 95, 243],  
        'cm' => ['Cm', 'Curio', 96, 247],  
        'bk' => ['Bk', 'Berkelio', 97, 247],  
        'cf' => ['Cf', 'Californio', 98, 251],  
        'es' => ['Es', 'Einstenio', 99, 252],  
        'fm' => ['Fm', 'Fermio', 100, 257],  
        'md' => ['Md', 'Mendelevio', 101, 258],  
        'no' => ['No', 'Nobelio', 102, 259],  
        'lr' => ['Lr', 'Lawrencio', 103, 262],  
        'rf' => ['Rf', 'Rutherfordio', 104, 267],  
        'db' => ['Db', 'Dubnio', 105, 268],  
        'sg' => ['Sg', 'Seaborgio', 106, 271],  
        'bh' => ['Bh', 'Bohrio', 107, 272],  
        'hs' => ['Hs', 'Hasio', 108, 270],  
        'mt' => ['Mt', 'Meitnerio', 109, 276],  
        'ds' => ['Ds', 'Darmstatio', 110, 281],  
        'rg' => ['Rg', 'Roentgenio', 111, 280],  
        'cn' => ['Cn', 'Copernicio', 112, 285],  
        'nh' => ['Nh', 'Nihonio', 113, 286],  
        'fl' => ['Fl', 'Flerovio', 114, 289],  
        'mc' => ['Mc', 'Moscovio', 115, 290],  
        'lv' => ['Lv', 'Livermorio', 116, 293],  
        'ts' => ['Ts', 'Teneso', 117, 294],  
        'og' => ['Og', 'Oganesón', 118, 294]  
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

    public static inline function exactSetGraphicSize(obj:Dynamic, width:Float, height:Float)
    {
        obj.scale.set(Math.abs(((obj.width - width) / obj.width) - 1), Math.abs(((obj.height - height) / obj.height) - 1));
    }
}