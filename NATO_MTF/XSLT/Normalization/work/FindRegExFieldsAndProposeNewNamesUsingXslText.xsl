<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsd" xml:lang="en-US" version="2.0">
	
	<xsl:output method="xml" indent="yes"/>
	
	<xsl:variable name="inputdoc" select="document('../Baseline_Schemas/fields.xsd')"/>
	
	<xsl:variable name="MTF_AND" select="'And'"/>																			<!-- And -->
	<xsl:variable name="MTF_OR" select="'Or'"/>																				<!-- Or -->
	<xsl:variable name="MTF_COMMA_CHAR" select="'CommaChar'"/>																<!-- , -->
	<xsl:variable name="MTF_DASH_CHAR" select="'DashChar'"/>																<!-- - -->
	<xsl:variable name="MTF_NEGATIVE_NUMBER_ALLOWED" select="'NegativeNumberAllowed'"/>
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE" select="'UpperAlphaAToZ'"/>										<!-- [A-Z] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_D_TYPE" select="'UpperAlphaAToD'"/>										<!-- [A-D] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE" select="'UpperAlphaAToF'"/>										<!-- [A-F] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_G_TYPE" select="'UpperAlphaAToG'"/>										<!-- [A-G] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_H_TYPE" select="'UpperAlphaAToH'"/>										<!-- [A-H] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_L_TYPE" select="'UpperAlphaAToL'"/>										<!-- [A-L] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_M_TYPE" select="'UpperAlphaAToM'"/>										<!-- [A-M] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_Q_TYPE" select="'UpperAlphaAToQ'"/>										<!-- [A-Q] -->
	<xsl:variable name="MTF_UPPER_ALPHA_CHAR_A_TO_Y_TYPE" select="'UpperAlphaAToY'"/>										<!-- [A-Y] -->
	<xsl:variable name="MTF_LOWER_ALPHA_CHAR_a_TO_z_TYPE" select="'LowerAlphaaToz'"/>										<!-- [a-z] -->

	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO" select="'NumericRangeZero'"/>												<!-- [0] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO_TO_ONE" select="'NumericRangeZeroToOne'"/>									<!-- [0-1] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO_TO_FOUR" select="'NumericRangeZeroToFour'"/>									<!-- [0-4] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO_TO_FIVE" select="'NumericRangeZeroToFive'"/>									<!-- [0-5] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO_TO_SIX" select="'NumericRangeZeroToSix'"/>									<!-- [0-6] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO_TO_SEVEN" select="'NumericRangeZeroToSeven'"/>								<!-- [0-7] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ZERO_TO_NINE" select="'NumericRangeZeroToNine'"/>									<!-- [0-9] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ONE_TO_THREE" select="'NumericRangeOneToThree'"/>									<!-- [1-3] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ONE_TO_FOUR" select="'NumericRangeOneToFour'"/>									<!-- [1-4] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ONE_TO_FIVE" select="'NumericRangeOneToFive'"/>									<!-- [1-5] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ONE_TO_SIX" select="'NumericRangeOneToSix'"/>										<!-- [1-6] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ONE_TO_EIGHT" select="'NumericRangeOneToEight'"/>									<!-- [1-8] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_ONE_TO_NINE" select="'NumericRangeOneToNine'"/>									<!-- [1-9] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_TWO_TO_SIX" select="'NumericRangeTwoToSix'"/>										<!-- [2-6] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_TWO_TO_NINE" select="'NumericRangeTwoToNine'"/>									<!-- [2-9] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_THREE_TO_SEVEN" select="'NumericRangeThreeToNSeven'"/>							<!-- [3-7] -->
	<xsl:variable name="MTF_NUMERIC_RANGE_FIVE_TO_NINE" select="'NumericRangeFiveToNine'"/>									<!-- [5-9] -->
	
	<xsl:variable name="MTF_DECIMAL_RANGE_ZERO_TO_NINE" select="'DecimalRangeZeroToNine'"/>									<!-- [0-9] -->
	<xsl:variable name="MTF_SLASH_ONLY_WITH_BLANK_CHAR_TYPE" select="'SlashOnlyWithBlankCharType'"/>						<!-- \'' -->
	<xsl:variable name="MTF_SLASH_ONLY_WITHOUT_BLANK_CHAR_TYPE" select="'SlashOnlyWithoutBlankCharType'"/>					<!-- \noblank -->
	<xsl:variable name="MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE" select="'SlashDashOnlyWithBlankCharType'"/> 				<!-- \-' ' -->
	<xsl:variable name="MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE" select="'SlashDashOnlyWithoutBlankCharType'"/> 		<!-- \-noblank -->
	<xsl:variable name="MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE" select="'SlashDashWithBlank'"/> 								<!-- \-\.,\(\)\? ' ' -->
	<xsl:variable name="MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE" select="'SlashDashWithoutBlank'"/> 							<!-- \-\.,\(\)\? noblank -->
	<xsl:variable name="MTF_SLASH_WITH_BLANK_CHAR_TYPE" select="'SlashWithBlank'"/> 										<!-- \' ' -->
	<xsl:variable name="MTF_SLASH_WITHOUT_BLANK_CHAR_TYPE" select="'SlashWithoutBlank'"/> 									<!-- \ noblank -->
	<xsl:variable name="MTF_BLANK_CHAR_TYPE" select="'BlankChar'"/>															<!-- ' ' -->
	<xsl:variable name="MTF_MULTPILE_BLANK_CHAR_TYPE" select="'MultipleBlankChar'"/>										<!-- '         ' -->
	<xsl:variable name="MTF_DOUBLE_LETTER_TYPE" select="'DoubleLetter'"/>													<!-- e.g. [AA]' ' -->
	<xsl:variable name="MTF_SIMPLE_TYPE" select="'SimpleType'"/>															<!-- SimpleType -->
	
	<xsl:variable name="MTF_MIN_MAX" select="'MinMax'"/>																	<!-- MinMax -->
	<xsl:variable name="MTF_MIN_MAX_NONE" select="'None'"/>																	<!-- {} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO" select="'ZeroDigit'"/>															<!-- {0,0} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_ONE" select="'ZeroToOne'"/>														<!-- {0,1} -->
	<xsl:variable name="MTF_MIN_MAX_ONE" select="'OneDigit'"/>																<!-- {1} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_ONE" select="'OneToOne'"/>														<!-- {1,1} -->
	<xsl:variable name="MTF_MIN_MAX_TWO" select="'TwoDigits'"/>																<!-- {2} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_TWO" select="'TwoToTwo'"/>														<!-- {2,2} -->
	<xsl:variable name="MTF_MIN_MAX_THREE" select="'ThreeDigits'"/>															<!-- {3,3} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR" select="'FourDigits'"/>															<!-- {4,4} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE" select="'FiveDigits'"/>															<!-- {5,5} -->
	<xsl:variable name="MTF_MIN_MAX_SIX" select="'SixDigits'"/>																<!-- {6,6} -->
	<xsl:variable name="MTF_MIN_MAX_SEVEN" select="'SevenDigits'"/>															<!-- {7,7} -->
	<xsl:variable name="MTF_MIN_MAX_EIGHT" select="'EightDigits'"/>															<!-- {8,8} -->
	<xsl:variable name="MTF_MIN_MAX_NINE" select="'NineDigit'"/>															<!-- {9,9} -->
	<xsl:variable name="MTF_MIN_MAX_TEN" select="'TenDigits'"/>																<!-- {10,10} -->
	<xsl:variable name="MTF_MIN_MAX_TWELVE" select="'TwelveDigits'"/>														<!-- {12,12} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_TWO" select="'ZeroToTwo'"/>														<!-- {0,2} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_THREE" select="'ZeroToThree'"/>													<!-- {0,3} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_FOUR" select="'ZeroToFour'"/>													<!-- {0,4} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_FIVE" select="'ZeroToFive'"/>													<!-- {0,5} -->
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_SIX" select="'ZeroToSix'"/>														<!-- {0,6} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWO" select="'OneToTwo'"/>														<!-- {1,2} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THREE" select="'OneToThree'"/>													<!-- {1,3} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FOUR" select="'OneToFour'"/>														<!-- {1,4} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIVE" select="'OneToFive'"/>														<!-- {1,5} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIX" select="'OneToSix'"/>														<!-- {1,6} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SEVEN" select="'OneToSeven'"/>													<!-- {1,7} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_EIGHT" select="'OneToEight'"/>													<!-- {1,8} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_NINE" select="'OneToNine'"/>														<!-- {1,9} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TEN" select="'OneToTen'"/>														<!-- {1,10} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_ELEVEN" select="'OneToEleven'"/>													<!-- {1,11} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWELVE" select="'OneToTwelve'"/>													<!-- {1,12} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTEEN" select="'OneToThirteen'"/>												<!-- {1,13} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FOURTEEN" select="'OneToFourteen'"/>												<!-- {1,14} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIFTEEN" select="'OneToFifteen'"/>												<!-- {1,15} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTEEN" select="'OneToSixteen'"/>												<!-- {1,16} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SEVENTEEN" select="'OneToSeventeen'"/>											<!-- {1,17} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_EIGHTEEN" select="'OneToEighteen'"/>												<!-- {1,18} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_NINETEEN" select="'OneToNineteen'"/>												<!-- {1,19} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY" select="'OneToTwenty'"/>													<!-- {1,20} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_ONE" select="'OneToTwentyOne'"/>											<!-- {1,21} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_TWO" select="'OneToTwentyTwo'"/>											<!-- {1,22} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_THREE" select="'OneToTwentyThree'"/>										<!-- {1,23} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_FOUR" select="'OneToTwentyFour'"/>										<!-- {1,24} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_FIVE" select="'OneToTwentyFive'"/>										<!-- {1,25} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_SIX" select="'OneToTwentySix'"/>											<!-- {1,26} --> 
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_EIGHT" select="'OneToTwentyEight'"/>										<!-- {1,28} --> 
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TWENTY_NINE" select="'OneToTwentyNine'"/>										<!-- {1,29} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY" select="'OneToThirty'"/>													<!-- {1,30} --> 
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_ONE" select="'OneToThirtyOne'"/>											<!-- {1,31} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_TWO" select="'OneToThirtyTwo'"/>											<!-- {1,32} --> 
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_THREE" select="'OneToThirtyThree'"/>										<!-- {1,33} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_FOUR" select="'OneToThirtyFour'"/>										<!-- {1,34} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_FIVE" select="'OneToThirtyFive'"/>										<!-- {1,35} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_SIX" select="'OneToThirtySix'"/>											<!-- {1,36} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_SEVEN" select="'OneToThirtySeven'"/>										<!-- {1,37} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_EIGHT" select="'OneToThirtyEight'"/>										<!-- {1,38} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_THIRTY_NINE" select="'OneToThirtyNine'"/>										<!-- {1,39} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FORTY" select="'OneToForty'"/>													<!-- {1,40} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FORTY_ONE" select="'OneToFortyOne'"/>											<!-- {1,41} -->	
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FORTY_THREE" select="'OneToFortyThree'"/>										<!-- {1,43} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FORTY_FIVE" select="'OneToFortyFive'"/>											<!-- {1,45} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FORTY_SIX" select="'OneToFortySix'"/>											<!-- {1,46} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FORTY_NINE" select="'OneToFortyNine'"/>											<!-- {1,49} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIFTY" select="'OneToFifty'"/>													<!-- {1,50} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIFTY_FOUR" select="'OneToFiftyFour'"/>											<!-- {1,54} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIFTY_FIVE" select="'OneToFiftyFive'"/>											<!-- {1,55} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIFTY_SIX" select="'OneToFiftySix'"/>											<!-- {1,56} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY" select="'OneToSixty'"/>													<!-- {1,60} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY_ONE" select="'OneToSixtyOne'"/>											<!-- {1,61} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY_TWO" select="'OneToSixtyTwo'"/>											<!-- {1,62} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY_THREE" select="'OneToSixtyThree'"/>										<!-- {1,63} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY_FOUR" select="'OneToSixtyFour'"/>											<!-- {1,64} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY_EIGHT" select="'OneToSixtyEight'"/>										<!-- {1,68} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIXTY_NINE" select="'OneToSixtyNine'"/>											<!-- {1,69} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_THREE" select="'TwoToThree'"/>													<!-- {2,3} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_FOUR" select="'TwoToFour'"/>														<!-- {2,4} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_FIVE" select="'TwoToFive'"/>														<!-- {2,5} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_SIX" select="'TwoToSix'"/>														<!-- {2,6} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_EIGHT" select="'TwoToEight'"/>													<!-- {2,8} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_NINE" select="'TwoToNine'"/>														<!-- {2,9} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_TEN" select="'TwoToTen'"/>														<!-- {2,10} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_ELEVEN" select="'TwoToEleven'"/>													<!-- {2,11} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_TWELVE" select="'TwoToTwelve'"/>													<!-- {2,12} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_THIRTEEN" select="'TwoToThirteen'"/>												<!-- {2,13} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_FIFTEEN" select="'TwoToFifteen'"/>												<!-- {2,15} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_SEVENTEEN" select="'TwoToSeventeen'"/>											<!-- {2,17} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_TWENTY" select="'TwoToTwenty'"/>													<!-- {2,20} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_TWENTY_FOUR" select="'TwoToTwentyFour'"/>										<!-- {2,24} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_TWENTY_FIVE" select="'TwoToTwentyFive'"/>										<!-- {2,25} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_THIRTY" select="'TwoToThirty'"/>													<!-- {2,30} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_THIRTY_TWO" select="'TwoToThirtyTwo'"/>											<!-- {2,32} -->
	<xsl:variable name="MTF_MIN_MAX_TWO_TO_FORTY_FIVE" select="'TwoToFortyFive'"/>											<!-- {2,45} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_OR_ONE" select="'ThreeOrOne'"/>													<!-- {3|1} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_OR_THREE" select="'ThreeOrThree'"/>												<!-- {3|3} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_THREE" select="'ThreeToThree'"/>												<!-- {3,3} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_FOUR" select="'ThreeToFour'"/>													<!-- {3,4} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_FIVE" select="'ThreeToFive'"/>													<!-- {3,5} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_SIX" select="'ThreeToSix'"/>													<!-- {3,6} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_SEVEN" select="'ThreeToSeven'"/>												<!-- {3,7} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_EIGHT" select="'ThreeToEight'"/>												<!-- {3,8} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_NINE" select="'ThreeToNine'"/>													<!-- {3,9} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_TEN" select="'ThreeToTen'"/>													<!-- {3,10} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_ELEVEN" select="'ThreeToEleven'"/>												<!-- {3,11} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_TWELVE" select="'ThreeToTwelve'"/>												<!-- {3,12} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_THIRTEEN" select="'ThreeToThirteen'"/>											<!-- {3,13} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_FIFTEEN" select="'ThreeToFifteen'"/>											<!-- {3,15} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_SIXTEEN" select="'ThreeToSixteen'"/>											<!-- {3,16} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_EIGHTEEN" select="'ThreeToEighteen'"/>											<!-- {3,18} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_TWENTY" select="'ThreeToTwenty'"/>												<!-- {3,20} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_TWENTY_SIX" select="'ThreeToTwentySix'"/>										<!-- {3,26} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_TWENTY_NINE" select="'ThreeToTwentyNine'"/>									<!-- {3,29} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_THIRTY" select="'ThreeToThirty'"/>												<!-- {3,30} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_THIRTY_SIX" select="'ThreeToThirtySix'"/>										<!-- {3,36} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_FIFTY" select="'ThreeToFifty'"/>												<!-- {3,50} -->
	<xsl:variable name="MTF_MIN_MAX_THREE_TO_FIFTY_FIVE" select="'ThreeToFiftyFive'"/>										<!-- {3,55} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_FOUR" select="'FourToFour'"/>													<!-- {4,4} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_FIVE" select="'FourToFive'"/>													<!-- {4,5} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_SIX" select="'FourToSix'"/>														<!-- {4,6} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_SEVEN" select="'FourToSeven'"/>													<!-- {4,7} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_EIGHT" select="'FourToEight'"/>													<!-- {4,8} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_TEN" select="'FourToTen'"/>														<!-- {4,10} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_TWELVE" select="'FourToTwelve'"/>												<!-- {4,12} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_FOURTEEN" select="'FourToFourteen'"/>											<!-- {4,14} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_TWENTY" select="'FourToTwenty'"/>												<!-- {4,20} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_TWENTY_FIVE" select="'FourToTwentyFive'"/>										<!-- {4,25} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_THIRTY_FIVE" select="'FourToThirtyFive'"/>										<!-- {4,35} -->
	<xsl:variable name="MTF_MIN_MAX_FOUR_TO_THIRTY_SEVEN" select="'FourToThirtySeven'"/>									<!-- {4,37} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_FIVE" select="'FiveToFive'"/>													<!-- {5,5} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_SIX" select="'FiveToSix'"/>														<!-- {5,6} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_SEVEN" select="'FiveToSeven'"/>													<!-- {5,7} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_EIGHT" select="'FiveToEight'"/>													<!-- {5,8} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_TEN" select="'FiveToTen'"/>														<!-- {5,10} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_FIFTEEN" select="'FiveToFifteen'"/>												<!-- {5,15} -->
	<xsl:variable name="MTF_MIN_MAX_FIVE_TO_FORTY" select="'FiveToForty'"/>													<!-- {5,40} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_SIX" select="'SixToSix'"/>														<!-- {6,6} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_SEVEN" select="'SixToSeven'"/>													<!-- {6,7} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_ELEVEN" select="'SixToEleven'"/>													<!-- {6,11} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_FIFTEEN" select="'SixToFifteen'"/>												<!-- {6,15} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_SIXTEEN" select="'SixToSixteen'"/>												<!-- {6,16} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_TWENTY" select="'SixToTwenty'"/>													<!-- {6,20} -->
	<xsl:variable name="MTF_MIN_MAX_SIX_TO_THIRTY" select="'SixToThirty'"/>													<!-- {6,30} -->
	<xsl:variable name="MTF_MIN_MAX_SEVEN_TO_TWENTY_THREE" select="'SevenToTwentyThree'"/>									<!-- {7,23} -->
	<xsl:variable name="MTF_MIN_MAX_SEVEN_TO_EIGHT" select="'SevenToEight'"/>												<!-- {7,8} -->
	<xsl:variable name="MTF_MIN_MAX_SEVEN_TO_TWELVE" select="'SevenToTwelve'"/>												<!-- {7,12} -->
	<xsl:variable name="MTF_MIN_MAX_EIGHT_TO_EIGHT" select="'EightToEight'"/>												<!-- {8,8} -->
	<xsl:variable name="MTF_MIN_MAX_EIGHT_TO_TEN" select="'EightToTen'"/>													<!-- {8,10} -->
	<xsl:variable name="MTF_MIN_MAX_EIGHT_TO_TWELVE" select="'EightToTwelve'"/>												<!-- {8,12} -->
	<xsl:variable name="MTF_MIN_MAX_EIGHT_TO_THIRTEEN" select="'EightToThirteen'"/>											<!-- {8,13} -->
	<xsl:variable name="MTF_MIN_MAX_EIGHT_TO_TWENTY" select="'EightToTwenty'"/>												<!-- {8,20} -->
	<xsl:variable name="MTF_MIN_MAX_NINE_TO_NINE" select="'NineToNine'"/>													<!-- {9,9} -->
	<xsl:variable name="MTF_MIN_MAX_NINE_TO_TWELVE" select="'NineToTwelve'"/>												<!-- {9,12} -->
	<xsl:variable name="MTF_MIN_MAX_NINE_TO_FOURTEEN" select="'NineToFourteen'"/>											<!-- {9,14} -->
	<xsl:variable name="MTF_MIN_MAX_NINE_TO_FIFTEEN" select="'NineToFifteen'"/>												<!-- {9,15} -->
	<xsl:variable name="MTF_MIN_MAX_TEN_TO_TEN" select="'TenToTen'"/>														<!-- {10,10} -->
	<xsl:variable name="MTF_MIN_MAX_ELEVEN_TO_ELEVEN" select="'ElevenToEleven'"/>											<!-- {11,11} -->
	<xsl:variable name="MTF_MIN_MAX_ELEVEN_TO_TWENTY_EIGHT" select="'ElevenToTwentyEight'"/>								<!-- {11,28} -->	
	<xsl:variable name="MTF_MIN_MAX_TWELVE_TO_TWELVE" select="'TwelveToTwelve'"/>											<!-- {12,12} -->
	<xsl:variable name="MTF_MIN_MAX_THIRTEEN_TO_FORTY_SEVEN" select="'ThirteenToFortySeven'"/>								<!-- {13,47} -->
	<xsl:variable name="MTF_MIN_MAX_FIFTEEN_TO_FIFTEEN" select="'FifteenToFifteen'"/>										<!-- {15,15} -->
	<xsl:variable name="MTF_MIN_MAX_SIXTEEN_TO_SIXTEEN" select="'SixteenToSixteen'"/>										<!-- {16,16} -->
	<xsl:variable name="MTF_MIN_MAX_SEVENTEEN_TO_SEVENTEEN" select="'SeventeenToSeventeen'"/>								<!-- {17,17} -->
	<xsl:variable name="MTF_MIN_MAX_TWENTY_TO_TWENTY" select="'TwentyToTwenty'"/>											<!-- {20,20} -->
	<xsl:variable name="MTF_MIN_MAX_THIRTY_TWO_TO_THIRTY_TWO" select="'ThirtyTwoToThirtyTwo'"/>								<!-- {32,32} -->
	<xsl:variable name="MTF_MIN_MAX_FORTY_TO_SIXTY_FOUR" select="'FortyToSixtyFour'"/>										<!-- {40,64} -->
	
	
	<xsl:variable name="MTF_MIN_MAX_ZERO_TO_SEVEN_DECIMAL_POINTS" select="'ZeroToSevenDecimalPoints'"/>						<!-- {0,7} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_ONE_DECIMAL_POINTS" select="'OneToOneDecimalPoints'"/>							<!-- {1,1} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FOUR_DECIMAL_POINTS" select="'OneToFourDecimalPoints'"/>							<!-- {1,4} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_FIVE_DECIMAL_POINTS" select="'OneToFiveDecimalPoints'"/>							<!-- {1,5} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SIX_DECIMAL_POINTS" select="'OneToSixDecimalPoints'"/>							<!-- {1,6} | {1}..{6} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_SEVEN_DECIMAL_POINTS" select="'OneToSevenDecimalPoints'"/>						<!-- {1,7} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_TEN_DECIMAL_POINTS" select="'OneToTenDecimalPoints'"/>							<!-- {1,10} -->
	<xsl:variable name="MTF_MIN_MAX_ONE_TO_ELEVEN_DECIMAL_POINTS" select="'OneToElevemDecimalPoints'"/>						<!-- {1,11} | {1}..{11} -->
	<xsl:variable name="MTF_COMMON_SLASH_DASH" select="concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>	<!-- [\-\.,\(\)\?A-Z0-9 ] -->
	
	<xsl:variable name="MTF_MHZ_FREQ_PATTERN" select="'MhzFequencyPattern'"/>												<!-- |\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}|[0-9]{6}\.[0-9]{1}|[0-9]{5}\.[0-9]{2}|[0-9]{4}\.[0-9]{3}|[0-9]{3}\.[0-9]{4}|[0-9]{2}\.[0-9]{5}|[0-9]{1}\.[0-9]{6}|\.[0-9]{7} -->
	<xsl:variable name="MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN" select="'MeasurementToNearestTenthPattern'"/>				<!-- .{1} -->
	<xsl:variable name="MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN" select="'MeasurementToNearestHundredthPattern'"/>		<!-- .{2} -->
	<xsl:variable name="MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN" select="'MeasurementToNearestThousandthPattern'"/>	<!-- .{3} -->
	<xsl:variable name="MTF_NATO_TRACK_NUMBER_ROOT_TYPE_PATTERN" select="'NATOTrackNumberRootTypePattern'"/>				<!-- [AEGHJ-M] -->
	<xsl:variable name="MTF_NATO_TRACK_NUMBER_SUBSET_TYPE_PATTERN" select="'NATOTrackNumberSubsetTypePattern'"/>			<!-- [0-7A-HJ-NP-Z] -->
	<xsl:variable name="MTF_DESIGNATED_SURFACE_CONTACTS_TYPE_PATTERN" select="'DesignatedSurfaceContactTypePattern'"/> 		<!-- [A-HJ-NP-Z] -->
	<xsl:variable name="MTF_UTM_GRID_TYPE_PATTERN" select="'UTMGridTypePattern'"/> 											<!-- [C-HJ-NP-X] -->
	<xsl:variable name="MTF_ALFA_DESIGNATION_FORMAT_PATTERN" select="'ALFADesignationFormatPattern'"/>						<!-- (PP|QQ|RR|SS|TT|UU|VV|WW|XX|YY|ZZ) -->
	<xsl:variable name="MTF_ZERO_DIGIT_PATTERN" select="'ZeroDigitPattern'"/>												<!-- 0 -->
	<xsl:variable name="MTF_COMBAT_NET_RADIO_PATTERN" select="'CombatNetRadioPattern'"/>									<!-- 188-220 -->
	<xsl:variable name="MTF_HEADER_VERSION_AND_SERIES_PATTERN" select="'HeaderVersionAndSeriesPattern'"/>					<!-- 2045-47001 -->
	<xsl:variable name="MTF_NINE_DIGIT_PATTERN" select="'NineDigitPattern'"/>												<!-- 9 -->
	<xsl:variable name="MTF_AIRCRAFT_READINESS_PATTERN" select="'AircraftReadinessPattern'"/>								<!-- RS -->
	<xsl:variable name="MTF_EMPTY_BRACKET_PATTERN" select="'EmptyBracketPattern'"/>											<!-- [ ] -->
	<xsl:variable name="MTF_PULSE_DURATION_IN_MICROSECONDS_PATTERN" select="'PulseDurationInMicrosecondsPattern'"/>			<!-- \.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{2}\.[0-9]{2}|[0-9]{3}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|[0-9]{2}\.[0-9]{3}|[0-9]{3}\.[0-9]{3} -->
	<xsl:variable name="MTF_MEASUREMENT_IN_HOURS_PATTERN" select="'MeasurementInHoursPattern'"/>							<!-- \.{1}|[0-9]{2}\.{1}|[0-9]{3}\.{1}|[0-9]{4}\.{1}|[0-9]{5}\.{1}|[0-9]{1}\.{2}|[0-9]{2}\.{2}|[0-9]{3}\.{2}|[0-9]{4}\.{2}|[0-9]{5}\.{2} -->
	<xsl:variable name="MTF_RUNWAY_DESIGNATOR_PATTERN" select="'RunwayDesignatorPattern'"/>									<!-- (C|L|R) -->
	<xsl:variable name="MTF_ANTENNA_AZIMUTH_TRUE_NORTH_DESIGNATOR_REFERENCE_PATTERN" select="'AntennaAzimuthTrueNorthReferencePattern'"/>	<!-- \.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{3}\.[0-9]{2} -->
	<xsl:variable name="MTF_STANAG_TYPE_PATTERN" select="'StanagTypePattern'"/>												<!-- ED[0-9]{1,2} -->
	<xsl:variable name="MTF_LINK22_NET_NUMBER_TYPE_PATTERN" select="'Link22NetNumberTypePattern'"/>							<!-- [0][0-9A-F]{2,2}|[1-2][0-9A-F]{2,2}|[3][E][0-7]|[3][0-9A-D][0-9A-F] -->
	<xsl:variable name="MTF_SINGLE_DIGIT_TYPE_PATTERN" select="'SingleDigitTypePattern'"/>									<!-- 1 -->
	<xsl:variable name="MTF_CST_CHANNEL_DATA_SIZE_TYPE_PATTERN" select="'CstChannelDataSizeTypePattern'"/>					<!-- [5678] -->
	<xsl:variable name="MTF_100K_METER_GRID_NORTH_SOUTH_DESIGNATION_TYPE_PATTERN" select="'100KMeterGridNorthSouthDesignationTypePattern'"/>	<!-- [A-HJ-NP-V] -->
	<xsl:variable name="MTF_SORTS_ORG_ID_TYPE_PATTERN" select="'SortsOrgIDTypePattern'"/>									<!-- [A-HJ-NP-Z0-9] -->
	<xsl:variable name="MTF_COMMUNITY_SEQUENCE_NO_TYPE_PATTERN" select="'CommunitySequenceNoTypePattern'"/>					<!-- [A-HJ-NP-Z1-9] -->
	<xsl:variable name="MTF_FIFTEEN_QUADRILATERAL_GEO_REF_TYPE_PATTERN" select="'FifteenDegreeQuadrilateralGeoRefTypePattern'"/>	<!-- [A-HJ-NP-Z]{1,1}[A-HJ-M]{1,1} -->
	<xsl:variable name="MTF_COLUMN_ALPHABETIC_INDICATOR_TYPE_PATTERN" select="'ColumnAlphabeticIndicatorTypePattern'"/>				<!-- [A-HJ-NP-Z]{1,1}|(AA|BB|CC|DD|EE|FF|GG|HH|JJ|KK|LL|MM|NN|PP|QQ|RR|SS|TT|UU|VV|WW|XX|YY|ZZ) -->
	<xsl:variable name="MTF_ONE_DEGREE_QUADRILATERAL_GEO_REF_TYPE_PATTERN" select="'OneDegreeQuadrilateralGeoRefTypePattern'"/>		<!-- [A-HJ-NPQ] -->
	<xsl:variable name="MTF_SUPPORTING_ADDRESS_PREFIX_TYPE_PATTERN" select="'SupportingUnitAddressPrefixTypePattern'"/>				<!-- [A-NP-Q]{1,1}[B-H] -->
	<xsl:variable name="MTF_VERSION_OF_MESSAGE_TEXT_FORMAT_TYPE_PATTERN" select="'VersionOfMessageTextFormatTypePattern'"/>			<!-- [A-Z0-9\.] -->
	<xsl:variable name="MTF_TRACK_END_DESIGNATOR_TYPE_PATTERN" select="'TrackEndDesignatorTypePattern'"/>							<!-- [A-Z]{1,1}|[A-D]{1,1}[A-Z]{1,1} -->
	<xsl:variable name="MTF_BROADCAST_GEOGRAPHICAL_AREA_TYPE_PATTERN" select="'BroadcastGeographicalAreaTypePattern'"/>				<!-- [A-Z]{1,1}|[A-Z]{1,1}[A-Z]{1,1} -->
	<xsl:variable name="MTF_TRACK_START_DESIGNATOR_TYPE_PATTERN" select="'TrackStartDesignatorTypePattern'"/>						<!-- [A-Z]|[A-D][A-Z] -->
	<xsl:variable name="MTF_UPRIGHT_SEQUENCE_TYPE_PATTERN" select="'UprightSequenceTypePattern'"/>									<!-- [CFGKM] -->
	<xsl:variable name="MTF_TRACK_OFFSET_IN_YARDS_TYPE_PATTERN" select="'TrackOffsetInYardsTypePattern'"/>							<!-- [\-0-9]{1,7}\.[0-9]{1} -->
	<xsl:variable name="MTF_INTERNET_PROTOCOL_ADDRESS_IPV6_TYPE_PATTERN" select="'InternetProtocolAddressIpv6TypePattern'"/>		<!-- [\-:A-Fa-f0-9] -->
	<xsl:variable name="MTF_STANDARD_OF_MESSAGE_TEXT_FORMAT_TYPE_PATTERN" select="'StandardOfMessageTextFormatTypePattern'"/>		<!-- [\-A-Z0-9\(\)] -->
	<xsl:variable name="MTF_DATA_LINK_LAYER_ADDRESS_DLAD_TYPE_PATTERN" select="'DataLinkLayerAddressDladTypePattern'"/>				<!-- [\-\.0-9A-F] -->
	<xsl:variable name="MTF_EXTENDED_OPERATIONAL_PARAM_SETTING_EOPS_NO_TYPE_PATTERN" select="'ExtendedOperationalParamaterSettingsEopsNumberTypePattern'"/>				<!-- [a-zA-Z]{1,1}[0-9]{1,2} -->
	<xsl:variable name="MTF_BIT_ERROR_RATE_TYPE_PATTERN" select="'BitErrorRateTypePattern'"/>										<!-- \.[0-9]{3}|\.[0-9]{4}|\.[0-9]{5} -->
	<xsl:variable name="MTF_MESSAGE_SERIAL_NUMBER_TYPE_PATTERN" select="'MessageSerialNumberTypePattern'"/>				<!-- [\-A-Z0-9&#x20;\.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&quot;';>&lt;~`\|]} -->
	<xsl:variable name="MTF_DEGREES_TYPE_PATTERN" select="'DegreesTypePattern'"/>				<!-- [0-9]{3}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1} -->
	
	<xsl:variable name="types">
		<TYPES>
			<Regex>
				<xsl:apply-templates select="$inputdoc/xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern]">
					<xsl:sort select="xsd:restriction/xsd:pattern/@value"/>
				</xsl:apply-templates>
			</Regex>
		</TYPES>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:result-document href="RegexNames.xml">
		<xsl:apply-templates select="$types/*" mode="sort">
			<xsl:sort select="@occurrence" order="descending" data-type="number"/>
		</xsl:apply-templates>
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="*" mode="sort">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="sort"/>
			<xsl:apply-templates select="*" mode="sort">
				<xsl:sort select="@occurrence" order="descending" data-type="number"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*" mode="sort">
		<xsl:copy-of select="."/>
	</xsl:template>
	

	<xsl:template match="xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern]">
		<xsl:variable name="regex">
			<xsl:value-of select="string(xsd:restriction/xsd:pattern/@value)"/>
		</xsl:variable>
		<xsl:variable name="occurrence">
			<xsl:value-of
				select="count(//xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern/@value=$regex])"
			/>
		</xsl:variable>
		<xsl:if
			test="not(preceding-sibling::xsd:simpleType[xsd:restriction/xsd:pattern/@value=$regex])">
			<xsl:element name="RegexType">
				<xsl:attribute name="regex">
					<xsl:value-of select="$regex"/>
				</xsl:attribute>
				<xsl:attribute name="occurrence">
					<xsl:value-of select="$occurrence"/>
				</xsl:attribute>
				<xsl:apply-templates select="xsd:restriction/xsd:pattern[@value=$regex]"/>
				<xsl:apply-templates
					select="//xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern/@value=$regex]"
					mode="group">
					<xsl:sort select="xsd:restriction/xsd:pattern/@value"/>
				</xsl:apply-templates>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	 
	
	<xsl:template match="xsd:schema/xsd:simpleType[xsd:restriction/xsd:pattern]" mode="group">
		<!--<xsl:element name="SType">
			<xsl:copy-of select="@name"/>
			<xsl:copy-of select="xsd:restriction/@base"/>
		</xsl:element>-->
	</xsl:template>
	
	
	<xsl:template match="xsd:pattern">
		<xsl:attribute name="regex">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:length">
		<xsl:attribute name="length">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:minLength">
		<xsl:attribute name="minlength">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:maxLength">
		<xsl:attribute name="maxLength">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:minInclusive">
		<xsl:attribute name="minInclusive">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:maxInclusive">
		<xsl:attribute name="maxInclusive">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>
	
	<!-- Proposed RegEx Names -->
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:pattern[@value='[0-9]{1,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,38}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_EIGHT,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{4,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,24}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_FOUR,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWELVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{4,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-7]{5,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,68}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_EIGHT,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,8}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}|[0-9]{6}\.[0-9]{1}|[0-9]{5}\.[0-9]{2}|[0-9]{4}\.[0-9]{3}|[0-9]{3}\.[0-9]{4}|[0-9]{2}\.[0-9]{5}|[0-9]{1}\.[0-9]{6}|\.[0-9]{7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat(MTF_MIN_MAX_ZERO_TO_SEVEN_DECIMAL_POINTS,concat($MTF_MHZ_FREQ_PATTERN,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{5,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWO,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{5,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOURTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0,3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_THREE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,13}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,25}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_FIVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,18}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,50}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,16}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0,2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_TWO,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,55}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FIFTY_FIVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0,4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_FOUR,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_DEGREES_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ELEVEN,$MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,28}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_EIGHT,$MTF_COMMON_SLASH_DASH)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,40}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FORTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,54}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTY_FOUR,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-7]{4,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,7}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{4}\.[0-9]{1}|[0-9]{5}\.[0-9]{1}|[0-9]{6}\.[0-9]{1}|[0-9]{7}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_MIN_MAX_ZERO_TO_SEVEN_DECIMAL_POINTS,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{12,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWELVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-7]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[1-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ONE_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,17}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVENTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,23}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_THREE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWENTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{3,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_ELEVEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-7]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWELVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,1}|(AA|BB|CC|DD|EE|FF|GG|HH|II|JJ|KK|LL|MM|NN|OO|PP|QQ|RR|SS|TT|UU|VV|WW|XX|YY|ZZ)']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_OR,concat($MTF_DOUBLE_LETTER_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9&#x20;\.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&quot;&quot;\;&gt;&lt;~`\|]{1,7}'">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_MESSAGE_SERIAL_NUMBER_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,21}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_ONE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[1-4]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ONE_TO_FOUR,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[1-5]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ONE_TO_FIVE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{4,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{5,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{4,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,19}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINETEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,35}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_FIVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWENTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0,5}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,5}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{10,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[AEGHJ-M]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_NATO_TRACK_NUMBER_ROOT_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{1,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,26}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_SIX,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,32}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,55}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTY_FIVE,MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,61}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_ONE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{4,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_SEVEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}[0-9]{1,6}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_FIVE_DECIMAL_POINTS,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{4,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{4,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{9,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,18}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,50}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTY,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{1,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{10,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{7,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{5,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{4,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,68}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{1,25}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,33}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_THREE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,36}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_SIX,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,60}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{10,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{4,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_TWENTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{8,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_EIGHT_TO_TWENTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWELVE,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOURTEEN,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{3,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWELVE,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-1]{1}\.[0-9]{1}|\.[0-9]{2}|[0-1]{1}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-5]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_FIVE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-7A-HJ-NP-Z]']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,concat($MTF_NATO_TRACK_NUMBER_SUBSET_TYPE_PATTERN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-7]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0,6}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ELEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,11}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}|[0-9]{6}\.[0-9]{1}|[0-9]{5}\.[0-9]{2}|[0-9]{4}\.[0-9]{3}|[0-9]{3}\.[0-9]{4}|[0-9]{2}\.[0-9]{5}|[0-9]{1}\.[0-9]{6}|\.[0-9]{7}|[0-9]{7}\.[0-9]{1}|[0-9]{6}\.[0-9]{2}|[0-9]{5}\.[0-9]{3}|[0-9]{4}\.[0-9]{4}|[0-9]{3}\.[0-9]{5}|[0-9]{2}\.[0-9]{6}|[0-9]{1}\.[0-9]{7}|\.[0-9]{8}|[0-9]{8}\.[0-9]{1}|[0-9]{7}\.[0-9]{2}|[0-9]{6}\.[0-9]{3}|[0-9]{5}\.[0-9]{4}|[0-9]{4}\.[0-9]{5}|[0-9]{3}\.[0-9]{6}|[0-9]{2}\.[0-9]{7}|[0-9]{1}\.[0-9]{8}|\.[0-9]{9}|[0-9]{9}\.[0-9]{1}|[0-9]{8}\.[0-9]{2}|[0-9]{7}\.[0-9]{3}|[0-9]{6}\.[0-9]{4}|[0-9]{5}\.[0-9]{5}|[0-9]{4}\.[0-9]{6}|[0-9]{3}\.[0-9]{7}|[0-9]{2}\.[0-9]{8}|[0-9]{1}\.[0-9]{9}|\.[0-9]{10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ELEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_TEN_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_FOUR_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3,4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{7,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{8,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_EIGHT,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[1-8]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ONE_TO_EIGHT,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-F1-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,concat($MTF_NUMERIC_RANGE_ONE_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-F]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-F]{1,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-Z]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_DESIGNATED_SURFACE_CONTACTS_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-Z]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_DESIGNATED_SURFACE_CONTACTS_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Q]{1,1}[A-H]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Q_TYPE,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_H_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWELVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,24}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-7]{4,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_SEVEN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{1,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOURTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{5,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_ELEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{4,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{5,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{8,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{2,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{2,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{4,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[C-HJ-NP-X]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UTM_GRID_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-,A-Z0-9]{1,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOURTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{2,3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THREE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,38}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_EIGHT,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,67}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_SEVEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9\.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,60}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{1,31}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_ONE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,29}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_NINE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,39}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_NINE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,41}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FORTY_ONE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,43}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FORTY_THREE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,45}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FORTY_FIVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,46}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FORTY_SIX,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWELVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,24}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWENTY_FOUR,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FIFTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THIRTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,36}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THIRTY_SIX,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{4,25}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_TWENTY_FIVE,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{6,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_ELEVEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{6,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_FIFTEEN,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{6,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_THIRTY,$MTF_COMMON_SLASH_DASH))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_NUMERIC_RANGE_ZERO_TO_NINE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{3,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SIX,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_NUMERIC_RANGE_ZERO_TO_NINE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{4,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_SEVEN,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_NUMERIC_RANGE_ZERO_TO_NINE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_NUMERIC_RANGE_ZERO_TO_NINE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{8,13}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_EIGHT_TO_THIRTEEN,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_NUMERIC_RANGE_ZERO_TO_NINE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{9,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE_TO_FIFTEEN,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_NUMERIC_RANGE_ZERO_TO_NINE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO,concat($MTF_SLASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='        ']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MULTPILE_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='(PP|QQ|RR|SS|TT|UU|VV|WW|XX|YY|ZZ)']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_ALFA_DESIGNATION_FORMAT_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='0[1-8]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_ZERO_DIGIT_PATTERN,concat($MTF_NUMERIC_RANGE_ONE_TO_EIGHT,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='188-220[A-Z]{0,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_ONE,concat($MTF_COMBAT_NET_RADIO_PATTERN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='2045-47001[A-Z]{0,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_ONE,concat($MTF_HEADER_VERSION_AND_SERIES_PATTERN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='9[5-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NINE_DIGIT_PATTERN,concat($MTF_NUMERIC_RANGE_FIVE_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='RS[0-9]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_AIRCRAFT_READINESS_PATTERN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[ ]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_EMPTY_BRACKET_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-1]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_ONE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-1]{1}|\.[0-9]{1}|[0]{1}\.[0-9]{1}|\.[0-9]{2}|[0]{1}\.[0-9]{1}|[0]{1}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_ONE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-4]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_FOUR,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-6]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_SIX,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9,]{1,26}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_COMMA_CHAR,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9A-F]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9A-F]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9A-F]{32,32}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THIRTY_TWO_TO_THIRTY_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9A-F]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9A-F]{8,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{0,1}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,12}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}|[0-9]{6}\.[0-9]{1}|[0-9]{5}\.[0-9]{2}|[0-9]{4}\.[0-9]{3}|[0-9]{3}\.[0-9]{4}|[0-9]{2}\.[0-9]{5}|[0-9]{1}\.[0-9]{6}|\.[0-9]{7}|[0-9]{7}\.[0-9]{1}|[0-9]{6}\.[0-9]{2}|[0-9]{5}\.[0-9]{3}|[0-9]{4}\.[0-9]{4}|[0-9]{3}\.[0-9]{5}|[0-9]{2}\.[0-9]{6}|[0-9]{1}\.[0-9]{7}|\.[0-9]{8}|[0-9]{8}\.[0-9]{1}|[0-9]{7}\.[0-9]{2}|[0-9]{6}\.[0-9]{3}|[0-9]{5}\.[0-9]{4}|[0-9]{4}\.[0-9]{5}|[0-9]{3}\.[0-9]{6}|[0-9]{2}\.[0-9]{7}|[0-9]{1}\.[0-9]{8}|\.[0-9]{9}|[0-9]{9}\.[0-9]{1}|[0-9]{8}\.[0-9]{2}|[0-9]{7}\.[0-9]{3}|[0-9]{6}\.[0-9]{4}|[0-9]{5}\.[0-9]{5}|[0-9]{4}\.[0-9]{6}|[0-9]{3}\.[0-9]{7}|[0-9]{2}\.[0-9]{8}|[0-9]{1}\.[0-9]{9}|\.[0-9]{10}|[0-9]{10}\.[0-9]{1}|[0-9]{9}\.[0-9]{2}|[0-9]{8}\.[0-9]{3}|[0-9]{7}\.[0-9]{4}|[0-9]{6}\.[0-9]{5}|[0-9]{5}\.[0-9]{6}|[0-9]{4}\.[0-9]{7}|[0-9]{3}\.[0-9]{8}|[0-9]{2}\.[0-9]{9}|[0-9]{1}\.[0-9]{10}|\.[0-9]{11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWELVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_ELEVEN_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,2}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,3}|\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{3}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,4}\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,5}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,5}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,5}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_FOUR_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,6}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,6}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{4}\.[0-9]{1}|[0-9]{5}\.[0-9]{1}|[0-9]{6}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,7}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_SIX_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,8}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}|[0-9]{6}\.[0-9]{1}|[0-9]{5}\.[0-9]{2}|[0-9]{4}\.[0-9]{3}|[0-9]{3}\.[0-9]{4}|[0-9]{2}\.[0-9]{5}|[0-9]{1}\.[0-9]{6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MHZ_FREQ_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1,9}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|\.[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|\.[0-9]{4}|[0-9]{4}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|\.[0-9]{5}|[0-9]{5}\.[0-9]{1}|[0-9]{4}\.[0-9]{2}|[0-9]{3}\.[0-9]{3}|[0-9]{2}\.[0-9]{4}|[0-9]{1}\.[0-9]{5}|\.[0-9]{6}|[0-9]{6}\.[0-9]{1}|[0-9]{5}\.[0-9]{2}|[0-9]{4}\.[0-9]{3}|[0-9]{3}\.[0-9]{4}|[0-9]{2}\.[0-9]{5}|[0-9]{1}\.[0-9]{6}|\.[0-9]{7}|[0-9]{7}\.[0-9]{1}|[0-9]{6}\.[0-9]{2}|[0-9]{5}\.[0-9]{3}|[0-9]{4}\.[0-9]{4}|[0-9]{3}\.[0-9]{5}|[0-9]{2}\.[0-9]{6}|[0-9]{1}\.[0-9]{7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ZERO_TO_SEVEN_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{15,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIFTEEN_TO_FIFTEEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{2}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|[0-9]{2}\.[0-9]{3}|[0-9]{1}\.[0-9]{4}|[0-9]{2}\.[0-9]{4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_FOUR_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{2}\.[0-9]{2}|[0-9]{3}\.[0-9]{2}|[0-9]{1}\.[0-9]{3}|[0-9]{2}\.[0-9]{3}|[0-9]{3}\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_PULSE_DURATION_IN_MICROSECONDS_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.[0-9]{3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_THOUSANDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}\.{1}|[0-9]{2}\.{1}|[0-9]{3}\.{1}|[0-9]{4}\.{1}|[0-9]{5}\.{1}|[0-9]{1}\.{2}|[0-9]{2}\.{2}|[0-9]{3}\.{2}|[0-9]{4}\.{2}|[0-9]{5}\.{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_IN_HOURS_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{1}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2,2}(C|L|R){0,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_RUNWAY_DESIGNATOR_PATTERN,concat($MTF_MIN_MAX_ZERO_TO_ONE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{2}|\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{2}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3,4}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}|[0-9]{4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SIX,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}\.[0-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MIN_MAX_ONE_TO_ONE_DECIMAL_POINTS,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}|[0-9]{1}\.[0-9]{1}|[0-9]{1}\.[0-9]{1}|[0-9]{2}\.[0-9]{1}|[0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_OR_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}|[0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[0-9]{2}\.[0-9]{1}|[0-9]{1}\.[0-9]{2}|[0-9]{3}\.[0-9]{1}|[0-9]{2}\.[0-9]{2}|[0-9]{3}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_OR_ONE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_ANTENNA_AZIMUTH_TRUE_NORTH_DESIGNATOR_REFERENCE_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}|[0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_OR_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{3}|[0-9]{3}\.[0-9]{1}|[0-9]{3}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_OR_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{4,4}ED[0-9]{1,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_STANAG_TYPE_PATTERN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{4,4}[A-Z]{0,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_F_TYPE,concat($MTF_MIN_MAX_ZERO_TO_ONE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{4}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{5,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0-9]{6,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_SEVEN,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0][0-9A-F]{2,2}|[1-2][0-9A-F]{2,2}|[3][E][0-7]|[3][0-9A-D][0-9A-F]']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_LINK22_NET_NUMBER_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[0]{1}\.[0-9]{1}|[0]{1}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_ZERO,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,$MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[1-3]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ONE_TO_THREE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[1-6]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_ONE_TO_SIX,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[2-6]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_TWO_TO_SIX,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[2-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_NUMERIC_RANGE_TWO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[2-9]|1[0-5]']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ZERO_TO_FIVE,concat($MTF_NUMERIC_RANGE_TWO_TO_NINE,concat($MTF_SINGLE_DIGIT_TYPE_PATTERN,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[3-7]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE,concat($MTF_NUMERIC_RANGE_THREE_TO_SEVEN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[5678]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_CST_CHANNEL_DATA_SIZE_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-D]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_D_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-G]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_G_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-V]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_100K_METER_GRID_NORTH_SOUTH_DESIGNATION_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-Z0-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_SORTS_ORG_ID_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-Z1-9]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_COMMUNITY_SEQUENCE_NO_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-Z]{1,1}[A-HJ-M]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_FIFTEEN_QUADRILATERAL_GEO_REF_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NP-Z]{1,1}|(AA|BB|CC|DD|EE|FF|GG|HH|JJ|KK|LL|MM|NN|PP|QQ|RR|SS|TT|UU|VV|WW|XX|YY|ZZ)']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_COLUMN_ALPHABETIC_INDICATOR_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-HJ-NPQ]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_ONE_DEGREE_QUADRILATERAL_GEO_REF_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-L]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_L_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-M]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_M_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-NP-Q]{1,1}[B-H]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_SUPPORTING_ADDRESS_PREFIX_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Y]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ONE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Y_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,19}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINETEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{11,28}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ELEVEN_TO_TWENTY_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{2,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWENTY,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{3,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWELVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{3,26}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWENTY_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{3,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{4,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{4,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FOURTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{4,37}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_THIRTY_SEVEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z ]{7,23}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN_TO_TWENTY_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[A-Z0-9 \.,\(\)&amp;\?\-!@#$%\^\*=_\+\[\]\{\}\\&#34;';&quot;&lt;~`\|a-z]{1,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN_TO_TWENTY_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{1,24}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{3,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{4,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9 ]{5,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<xsl:variable name="freetext"><xsl:text>[A-Z0-9\.,\(\)\?\-!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~\|a-z\t\n]|([:A-Z0-9\.,\(\)\?\-!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~\|a-z\t\n][/:A-Z0-9&#x20;\.,\(\)\?\-!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z\t\n]*[A-Z0-9\.,\(\)\?\-!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~\|a-z\t\n])</xsl:text></xsl:variable>
	<xsl:template match="xsd:pattern[@value=$freetext]">
		<xsl:attribute name="ProposedName">
			<xsl:text>FREETEXT_PATTERN</xsl:text>
<!--			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))))"/>-->
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9\.]{9,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE_TO_NINE,concat($MTF_VERSION_OF_MESSAGE_TEXT_FORMAT_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{1,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOURTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{16,16}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_SIXTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{17,17}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVENTEEN_TO_SEVENTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,25}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWENTY_FIVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{2,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_NINE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{3,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THIRTY,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{4,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{40,64}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FORTY_TO_SIXTY_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{5,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{5,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z0-9]{7,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN_TO_EIGHT,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,1}|[A-D]{1,1}[A-Z]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_TRACK_END_DESIGNATOR_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,1}|[A-Z]{1,1}[A-Z]{1,1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_BROADCAST_GEOGRAPHICAL_AREA_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{1,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIX,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{2,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TEN,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{2,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THREE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]{3,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWELVE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[A-Z]|[A-D][A-Z]']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_TRACK_START_DESIGNATOR_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[CFGKM]{1,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ELEVEN,concat($MTF_UPRIGHT_SEQUENCE_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\- \.,\(\)\?A-Z0-9]{1,60}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,22}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_TWO,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_NEGATIVE_NUMBER_ALLOWED,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,3}|\.[0-9]{1}|[\-0-9]{1}\.[0-9]{1}|[\-0-9]{2}\.[0-9]{1}|[\-0-9]{3}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_TENTH_PATTERN,concat($MTF_NEGATIVE_NUMBER_ALLOWED,$MTF_SIMPLE_TYPE))))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,5}|\.[0-9]{1}|[\-0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[\-0-9]{2}\.[0-9]{1}|[\-0-9]{1}\.[0-9]{2}|[\-0-9]{3}\.[0-9]{1}|[\-0-9]{2}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,concat($MTF_NEGATIVE_NUMBER_ALLOWED,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,5}|\.[0-9]{1}|[\-0-9]{1}\.[0-9]{1}|\.[0-9]{2}|[\-0-9]{2}\.[0-9]{1}|[\-0-9]{1}\.[0-9]{2}|[\-0-9]{3}\.[0-9]{1}|[\-0-9]{2}\.[0-9]{2}|[\-0-9]{4}\.[0-9]{1}|[\-0-9]{3}\.[0-9]{2}|[\-0-9]{5}\.[0-9]{1}|[\-0-9]{4}\.[0-9]{2}|[\-0-9]{5}\.[0-9]{2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIVE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_MEASUREMENT_TO_NEAREST_HUNDREDTH_PATTERN,concat($MTF_NEGATIVE_NUMBER_ALLOWED,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{1,7}\.[0-9]{1}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_TRACK_OFFSET_IN_YARDS_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{3,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FOUR,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_NEGATIVE_NUMBER_ALLOWED,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-0-9]{3,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FIVE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,concat($MTF_NEGATIVE_NUMBER_ALLOWED,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-:A-Fa-f0-9]{2,45}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FORTY_FIVE,concat($MTF_INTERNET_PROTOCOL_ADDRESS_IPV6_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-:A-Z0-9 \.,\(\)\?!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z\t\n]([:A-Z0-9 \.,\(\)\?\-!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z\t\n]|/[:A-Z0-9 \.,\(\)\?\-!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z\t\n]|://)*']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FORTY_FIVE,concat($MTF_INTERNET_PROTOCOL_ADDRESS_IPV6_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[\-;\.,\(\)\?A-Z0-9 ]{1,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-;\.,\(\)\?A-Z0-9 ]{1,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-A-Z ]{1,32}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<xsl:variable name="test"><text>[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|]{1,10}</text></xsl:variable>
	<xsl:template match="xsd:pattern[@value=$test]">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|]{1,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,35}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,40}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,43}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,50}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,54}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,62}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)\?!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;'; ~`\|]{1,60}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 \.,\(\)\?!@#$%\^&amp;\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|]{1,13}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_SLASH_DASH_ONLY_WITH_BLANK_CHAR_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 ]{1,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTEEN,concat($MTF_SLASH_ONLY_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DASH_CHAR,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 ]{1,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_SLASH_ONLY_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DASH_CHAR,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-A-Z0-9 ]{1,32}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_TWO,concat($MTF_SLASH_ONLY_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_DASH_CHAR,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-A-Z0-9\(\)]{20,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWENTY_TO_TWENTY,concat($MTF_STANDARD_OF_MESSAGE_TEXT_FORMAT_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-A-Z0-9a-z]{1,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_LOWER_ALPHA_CHAR_a_TO_z_TYPE,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Za-z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,40}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_LOWER_ALPHA_CHAR_a_TO_z_TYPE,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<!-- Pattern Value Error -->
	<!--<xsl:template match="xsd:pattern[@value='[\-A-Za-z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;';&gt;&lt;~`\|a-z]{1,45}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,concat($MTF_LOWER_ALPHA_CHAR_a_TO_z_TYPE,$MTF_SIMPLE_TYPE))))))"/>
		</xsl:attribute>
	</xsl:template>-->
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?0-9 ]{2,13}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THIRTEEN,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?0-9]{16,16}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIXTEEN_TO_SIXTEEN,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?0-9]{4,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FOUR,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?0-9]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_SIX,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?0-9]{9,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE_TO_NINE,concat($MTF_SLASH_DASH_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{1,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TEN,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{1,17}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVENTEEN,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{1,35}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_FIVE,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{3,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWENTY,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z ]{4,25}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_TWENTY_FIVE,concat($MTF_SLASH_DASH_WITH_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,$MTF_SIMPLE_TYPE))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,22}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_TWO,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,34}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_FOUR,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,37}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_SEVEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,47}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTY_SEVEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,49}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FORTY_NINE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,56}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FIFTY_SIX,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,62}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_TWO,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,63}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_THREE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,64}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_FOUR,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{1,69}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SIXTY_NINE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{12,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWELVE_TO_TWELVE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{13,47}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THIRTEEN_TO_FORTY_SEVEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FIFTEEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,17}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_SEVENTEEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,25}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWENTY_FIVE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,30}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THIRTY,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,32}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_THIRTY_TWO,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{2,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_EIGHT,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,13}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THIRTEEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,29}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_TWENTY_NINE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THREE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,50}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_FIFTY,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{3,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SEVEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{4,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_TWELVE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{4,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FOURTEEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{4,35}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_THIRTY_FIVE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{5,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_FIFTEEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{5,40}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_FORTY,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{6,20}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_TWENTY,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{6,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIX_TO_SIX,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{7,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN_TO_TWELVE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{8,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_EIGHT_TO_TEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{8,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_EIGHT_TO_TWELVE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{9,14}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE_TO_FOURTEEN,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9 ]{9,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE_TO_NINE,concat($MTF_COMMON_SLASH_DASH,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_ELEVEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,13}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THIRTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,18}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_THREE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,4}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_FOUR,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{1,9}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_NINE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{10,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TEN_TO_TEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{11,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ELEVEN_TO_ELEVEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{16,16}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SIXTEEN_TO_SIXTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{2,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_ELEVEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{2,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWELVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{2,15}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_FIFTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{2,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_TWO,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{3,18}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_EIGHTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{3,3}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_THREE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{4,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FOUR_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{5,10}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_TEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{5,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{5,6}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_SIX,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{7,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_SEVEN_TO_EIGHT,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z0-9]{9,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_NINE_TO_TWELVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z]{1,7}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_SEVEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z]{1,8}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_EIGHT,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z]{3,16}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_THREE_TO_SIXTEEN,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.,\(\)\?A-Z]{5,5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_FIVE_TO_FIVE,concat($MTF_SLASH_DASH_ONLY_WITHOUT_BLANK_CHAR_TYPE,concat($MTF_UPPER_ALPHA_CHAR_A_TO_Z_TYPE,concat($MTF_NUMERIC_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\-\.0-9A-F]{1,21}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWENTY_ONE,concat($MTF_DATA_LINK_LAYER_ADDRESS_DLAD_TYPE_PATTERN,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\.0-9]{1,12}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_ONE_TO_TWELVE,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[\.0-9]{2,11}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_MIN_MAX,concat($MTF_MIN_MAX_TWO_TO_ELEVEN,concat($MTF_DECIMAL_RANGE_ZERO_TO_NINE,$MTF_SIMPLE_TYPE)))"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='[a-zA-Z]{1,1}[0-9]{1,2}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_EXTENDED_OPERATIONAL_PARAM_SETTING_EOPS_NO_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="xsd:pattern[@value='\.[0-9]{3}|\.[0-9]{4}|\.[0-9]{5}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat($MTF_BIT_ERROR_RATE_TYPE_PATTERN,$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
	<!---TEMP FIX ERROR TEST -->
	<xsl:template match="xsd:pattern[@value='[\-A-Za-z0-9 \.,\(\)&amp;\?!@#$%\^\*=_\+\[\]\{\}\\&#34;&quot;\;&gt;&lt;~`\|a-z]{1,45}']">
		<xsl:attribute name="ProposedName">
			<xsl:value-of select="concat('FIXME!',$MTF_SIMPLE_TYPE)"/>
		</xsl:attribute>
	</xsl:template>
</xsl:stylesheet>