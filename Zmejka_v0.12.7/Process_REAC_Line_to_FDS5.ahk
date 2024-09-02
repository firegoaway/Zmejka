Process_Reac_Line_to_FDS5(filePath)
{
    FileRead, fileContent, %filePath%

    reLine := ""
    mwValue := ""

    if RegExMatch(fileContent, "(?s)&REAC(.*?)\/", reLine)
	{
        heatValue := ""
        if RegExMatch(reLine, "HEAT_OF_COMBUSTION=([0-9]+)", heatValue)
		{
            heatValue := heatValue1
            ToolTip, Found HEAT_OF_COMBUSTION: %heatValue%
			Sleep, 500
			ToolTip
        }
		else
		{
            ToolTip, HEAT_OF_COMBUSTION not found in &REAC line.
			Sleep, 500
			ToolTip
            return
        }

        if RegExMatch(fileContent, "(?s)&SPEC(.*?)MW=([0-9]+\.[0-9]+)", specMatch)
		{
            mwValue := specMatch2
            ToolTip, Found MW: %mwValue%
			Sleep, 500
			ToolTip
        }
		else
		{
            ToolTip, MW not found in any &SPEC line.
			Sleep, 500
			ToolTip
            return
        }
		
		
		
		
        if (heatValue = "15800" && mwValue = "87.17236")
		{
            newReacLine := "&REAC FUEL='Magazin' HEAT_OF_COMBUSTION=15800 C=2.04063566380017 H=12.6343784487717 O=2.99531473248877 OTHER=0.0549893743825584 MW_OTHER=36.46094 CO_YIELD=0.043 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "29000" && mwValue = "58.08")
		{
            newReacLine := "&REAC FUEL='Aceton' HEAT_OF_COMBUSTION=29000 C=3.62794361564637 H=4.18829613026328 O=0.642793267861293 MW_OTHER=36.46094 CO_YIELD=0.269 SOOT_YIELD=0.00919540229885057 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "43200" && mwValue = "97.27816")
		{
            newReacLine := "&REAC FUEL='Benzin A-76' HEAT_OF_COMBUSTION=43200 C=7.2982305067397 H=13.8558240096209 O=-0.271543642269286 MW_OTHER=36.46094 CO_YIELD=0.175 SOOT_YIELD=0.0294252873563218 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14500" && mwValue = "87.15314")
		{
            newReacLine := "&REAC FUEL='Biblioteki, arxivy' HEAT_OF_COMBUSTION=14500 C=2.53955051032171 H=9.10635854734048 O=2.95898396960324 OTHER=0.00358547283750775 MW_OTHER=36.46094 CO_YIELD=0.0974 SOOT_YIELD=0.00568965517241379 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "15100" && mwValue = "87.17473")
		{
            newReacLine := "&REAC FUEL='Bumaga v rulonax' HEAT_OF_COMBUSTION=15100 C=1.68335080957183 H=13.3794212131738 O=3.342053749796 MW_OTHER=36.46094 CO_YIELD=0.1077 SOOT_YIELD=0.00471264367816092 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "23300" && mwValue = "87.3329")
		{
            newReacLine := "&REAC FUEL='Verxnyaya odezhda' HEAT_OF_COMBUSTION=23300 C=1.07874842870031 H=29.7203232909607 O=2.76817097605349 OTHER=0.00359286814876413 MW_OTHER=36.46094 CO_YIELD=0.0145 SOOT_YIELD=0.0148275862068966 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16720" && mwValue = "87.24597")
		{
            newReacLine := "&REAC FUEL='Veshala tekstilnyx izdelij' HEAT_OF_COMBUSTION=16720 C=1.9892540840894 H=25.2950527343153 O=2.36619752887441 MW_OTHER=36.46094 CO_YIELD=0.063 SOOT_YIELD=0.00701149425287356 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14000" && mwValue = "87.14469")
		{
            newReacLine := "&REAC FUEL='Vystavochnyj zal' HEAT_OF_COMBUSTION=14000 C=2.93307983378663 H=7.41369929580519 O=2.77729600471004 OTHER=0.000239008347014641 MW_OTHER=36.46094 CO_YIELD=0.023 SOOT_YIELD=0.00609195402298851 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16700" && mwValue = "87.24592")
		{
            newReacLine := "&REAC FUEL='Garderob' HEAT_OF_COMBUSTION=16700 C=1.99123537785576 H=25.1594374723412 O=2.3023606576239 OTHER=0.0311071782570608 MW_OTHER=36.46094 CO_YIELD=0.063 SOOT_YIELD=0.00701149425287356 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14100" && mwValue = "87.14178")
		{
            newReacLine := "&REAC FUEL='Derevo + kraska' HEAT_OF_COMBUSTION=14100 C=3.07818722576679 H=6.81626494686248 O=2.70091810185193 OTHER=0.00239000365870984 MW_OTHER=36.46094 CO_YIELD=0.0349 SOOT_YIELD=0.00819540229885057 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13900" && mwValue = "87.17743")
		{
            newReacLine := "&REAC FUEL='Derevo + lak. pokrytie' HEAT_OF_COMBUSTION=13900 C=1.55094254998392 H=13.9292073595896 O=3.40426082036623 OTHER=0.00119549070868716 MW_OTHER=36.46094 CO_YIELD=0.0205 SOOT_YIELD=0.00736781609195402 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14400" && mwValue = "87.14166")
		{
            newReacLine := "&REAC FUEL='Derevo + oblicovka' HEAT_OF_COMBUSTION=14400 C=3.25276401757142 H=6.66388896500806 O=2.56529478002899 OTHER=0.00860400132305969 MW_OTHER=36.46094 CO_YIELD=0.0367 SOOT_YIELD=0.00966666666666667 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "45400" && mwValue = "203.7338")
		{
            newReacLine := "&REAC FUEL='Dizelnoe toplivo; solyar' HEAT_OF_COMBUSTION=45400 C=16.7277592546309 H=23.0161597841437 O=-1.27362281389276 MW_OTHER=36.46094 CO_YIELD=0.122 SOOT_YIELD=0.0712758620689655 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13357")
		{
            newReacLine := "&REAC FUEL='Drevesina (lesopilnyj cex I-III st. ognest.)' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13357")
		{
            newReacLine := "&REAC FUEL='Drevesina (lesopilnyj cex IV-V st. ognest.)' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13357")
		{
            newReacLine := "&REAC FUEL='Drevesina (cex derevoobrabotki)' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13357")
		{
            newReacLine := "&REAC FUEL='Drevesina (cex sushki drevesiny)' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Drevesina (cex sushki drevesiny)' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16200" && mwValue = "87.19306")
		{
            newReacLine := "&REAC FUEL='Zal' HEAT_OF_COMBUSTION=16200 C=1.89147041195327 H=16.2930390784168 O=2.92547910557085 OTHER=0.03419716436274 MW_OTHER=36.46094 CO_YIELD=0.041 SOOT_YIELD=0.020183908045977 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16200" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Zal vokzala' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Zal teatra' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Zal teatra' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19463")
		{
            newReacLine := "&REAC FUEL='Zanaves zritelnogo zala' HEAT_OF_COMBUSTION=13800 C=0.450383259079194 H=17.6131611161992 O=4.00216272850462 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.00574712643678161 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13357")
		{
            newReacLine := "&REAC FUEL='Zritelnyj zal' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "15400" && mwValue = "87.16675")
		{
            newReacLine := "&REAC FUEL='Izdatelstva, tipografii' HEAT_OF_COMBUSTION=15400 C=2.08687907211282 H=11.7447222729489 O=3.14161132988622 MW_OTHER=36.46094 CO_YIELD=0.169 SOOT_YIELD=0.00471264367816092 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "42700" && mwValue = "304.1051")
		{
            newReacLine := "&REAC FUEL='Industrialnoe maslo' HEAT_OF_COMBUSTION=42700 C=10.1022722317347 H=45.4549494739891 O=8.55993870299842 MW_OTHER=36.46094 CO_YIELD=0.122 SOOT_YIELD=0.0551724137931034 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "33500" && mwValue = "104.3429")
		{
            newReacLine := "&REAC FUEL='Kabeli + provoda' HEAT_OF_COMBUSTION=33500 C=2.5290821593163 H=29.6078190265837 O=2.66654686366015 OTHER=0.0400648090806216 MW_OTHER=36.46094 CO_YIELD=0.0995 SOOT_YIELD=0.0703448275862069 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "30700" && mwValue = "104.3282")
		{
            newReacLine := "&REAC FUEL='Kabelnyj podval, lotok' HEAT_OF_COMBUSTION=30700 C=2.53859577355986 H=27.0485727873687 O=2.77929934483471 OTHER=0.0577996519014595 MW_OTHER=36.46094 CO_YIELD=0.1295 SOOT_YIELD=0.0598850574712644 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "43000" && mwValue = "104.3386")
		{
            newReacLine := "&REAC FUEL='Kauchuk' HEAT_OF_COMBUSTION=43000 C=4.10660071805739 H=27.7959037478 O=1.65488427467332 OTHER=0.0143082707138104 MW_OTHER=36.46094 CO_YIELD=0.15 SOOT_YIELD=0.024367816091954 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "15800" && mwValue = "87.173")
		{
            newReacLine := "&REAC FUEL='Kayuta' HEAT_OF_COMBUSTION=15800 C=1.91636797685625 H=12.817324246908 O=3.07711581867807 OTHER=0.0549897781022651 MW_OTHER=36.46094 CO_YIELD=0.0425 SOOT_YIELD=0.0153448275862069 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "43300" && mwValue = "191.8475")
		{
            newReacLine := "&REAC FUEL='Kerosin' HEAT_OF_COMBUSTION=43300 C=14.5395483538175 H=26.1287887880536 O=-0.569952700875589 MW_OTHER=36.46094 CO_YIELD=0.148 SOOT_YIELD=0.0503563218390805 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "41200" && mwValue = "106.0573")
		{
            newReacLine := "&REAC FUEL='Ksilol' HEAT_OF_COMBUSTION=41200 C=9.77754001685807 H=9.13212388187722 O=-1.28645018121409 MW_OTHER=36.46094 CO_YIELD=0.148 SOOT_YIELD=0.0462068965517241 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "26600" && mwValue = "48.37055")
		{
            newReacLine := "&REAC FUEL='Lekarstvennye preparaty' HEAT_OF_COMBUSTION=26600 C=2.59431881616777 H=6.01815123815808 O=0.696590485595959 MW_OTHER=36.46094 CO_YIELD=0.262 SOOT_YIELD=0.0101264367816092 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "15700" && mwValue = "87.23259")
		{
            newReacLine := "&REAC FUEL='Len razryxlennyj' HEAT_OF_COMBUSTION=15700 C=0.728500340960467 H=23.8789838196466 O=3.4010155390852 MW_OTHER=36.46094 CO_YIELD=0.0039 SOOT_YIELD=0.00038735632183908 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13358")
		{
            newReacLine := "&REAC FUEL='Listvennye drevesnye strojmaterialy' HEAT_OF_COMBUSTION=13800 C=3.22685922029608 H=5.32428923532511 O=2.68823693798169 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00609195402298851 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "15700" && mwValue = "87.23259")
		{
            newReacLine := "&REAC FUEL='Lnovolokno' HEAT_OF_COMBUSTION=15700 C=0.728525154105243 H=23.8789531825622 O=3.400998842035 MW_OTHER=36.46094 CO_YIELD=0.0039 SOOT_YIELD=0.000390804597701149 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14280" && mwValue = "87.1877")
		{
            newReacLine := "&REAC FUEL='Mebel + bumaga' HEAT_OF_COMBUSTION=14280 C=1.7751799507728 H=15.5213976815217 O=3.1346274667892 OTHER=0.00191301047093136 MW_OTHER=36.46094 CO_YIELD=0.068 SOOT_YIELD=0.00832183908045977 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14002" && mwValue = "87.14002")
		{
            newReacLine := "&REAC FUEL='Mebel + bumaga (Admin. pomeshhenie)' HEAT_OF_COMBUSTION=14002 C=3.01692338292962 H=6.56295632313326 O=2.76820332780796 MW_OTHER=36.46094 CO_YIELD=0.043 SOOT_YIELD=0.00609195402298851 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14002" && mwValue = "87.17929")
		{
            newReacLine := "&REAC FUEL='Mebel + bumaga (Kabinet)' HEAT_OF_COMBUSTION=14002 C=1.41422410470812 H=14.3405501053974 O=3.48382155999963 MW_OTHER=36.46094 CO_YIELD=0.0317 SOOT_YIELD=0.00609195402298851 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Mebel + bytovye izdeliya (zdanie I-II st. ognest.)' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Mebel + bytovye izdeliya (zdanie III-IV st. ognest.)' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14000" && mwValue = "87.15015")
		{
            newReacLine := "&REAC FUEL='Mebel + linoleum' HEAT_OF_COMBUSTION=14000 C=3.05957794463888 H=8.22551013563174 O=2.60048413061725 OTHER=0.0138633526727506 MW_OTHER=36.46094 CO_YIELD=0.03 SOOT_YIELD=0.00548275862068966 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14900" && mwValue = "87.16236")
		{
            newReacLine := "&REAC FUEL='Mebel + tkani (zdanie I st. ognest.)' HEAT_OF_COMBUSTION=14900 C=2.72271113082133 H=10.562191490723 O=2.7385175909571 MW_OTHER=36.46094 CO_YIELD=0.0193 SOOT_YIELD=0.00672413793103448 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14900" && mwValue = "87.16236")
		{
            newReacLine := "&REAC FUEL='Mebel + tkani (zdanie III st. ognest.)' HEAT_OF_COMBUSTION=14900 C=2.72271113082133 H=10.562191490723 O=2.7385175909571 MW_OTHER=36.46094 CO_YIELD=0.0193 SOOT_YIELD=0.00672413793103448 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14700" && mwValue = "87.16459")
		{
            newReacLine := "&REAC FUEL='Mebel + tkani (zdanie I-II st. ognest.)' HEAT_OF_COMBUSTION=14700 C=2.61966863380592 H=10.9845790894423 O=2.75671288009136 OTHER=0.0143437755581727 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.00942528735632184 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14700" && mwValue = "87.16459")
		{
            newReacLine := "&REAC FUEL='Mebel + tkani (zdanie III-IV st. ognest.)' HEAT_OF_COMBUSTION=14700 C=2.61966863380592 H=10.9845790894423 O=2.75671288009136 OTHER=0.0143437755581727 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.00942528735632184 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Muzei, vystavki' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "44200" && mwValue = "97.25767")
		{
            newReacLine := "&REAC FUEL='Neft' HEAT_OF_COMBUSTION=44200 C=7.82254093203049 H=10.0286041611257 O=-0.42531294019577 MW_OTHER=36.46094 CO_YIELD=0.161 SOOT_YIELD=0.0503448275862069 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "18100" && mwValue = "87.17672")
		{
            newReacLine := "&REAC FUEL='Paneli DVP' HEAT_OF_COMBUSTION=18100 C=1.53324081520906 H=13.8279642542338 O=3.42660766828336 MW_OTHER=36.46094 CO_YIELD=0.0215 SOOT_YIELD=0.0149425287356322 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14000" && mwValue = "87.17929")
		{
            newReacLine := "&REAC FUEL='Podsobnye pomeshheniya' HEAT_OF_COMBUSTION=14000 C=1.41422410470812 H=14.3405501053974 O=3.48382155999963 MW_OTHER=36.46094 CO_YIELD=0.0317 SOOT_YIELD=0.00609195402298851 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "34800" && mwValue = "104.4005")
		{
            newReacLine := "&REAC FUEL='Polietilen, polistirol, polipropilen' HEAT_OF_COMBUSTION=34800 C=2.56225134770071 H=39.4127923036339 O=2.07121616372177 OTHER=0.0209024685046518 MW_OTHER=36.46094 CO_YIELD=0.1 SOOT_YIELD=0.0437931034482759 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "37800" && mwValue = "104.4019")
		{
            newReacLine := "&REAC FUEL='Provoda v rezinovoj izolyacii' HEAT_OF_COMBUSTION=37800 C=1.88418166165421 H=40.2112321913757 O=2.57766251740733 MW_OTHER=36.46094 CO_YIELD=0.015 SOOT_YIELD=0.0977011494252874 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16700" && mwValue = "87.24599")
		{
            newReacLine := "&REAC FUEL='Promtovary, tekstilnye izdeliya' HEAT_OF_COMBUSTION=16700 C=1.98767772548429 H=25.2993414007795 O=2.36711196631281 MW_OTHER=36.46094 CO_YIELD=0.0626 SOOT_YIELD=0.00696551724137931 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16700" && mwValue = "87.24599")
		{
            newReacLine := "&REAC FUEL='Pshenica, ris, grechixa' HEAT_OF_COMBUSTION=17000 C=3.02079876706925 H=8.48926110574166 O=2.64461607526432 MW_OTHER=36.46094 CO_YIELD=0.163 SOOT_YIELD=0.125977011494253 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "36000" && mwValue = "104.4019")
		{
            newReacLine := "&REAC FUEL='Rezina' HEAT_OF_COMBUSTION=36000 C=1.88418166165421 H=40.2112321913757 O=2.57766251740733 MW_OTHER=36.46094 CO_YIELD=0.015 SOOT_YIELD=0.0977011494252874 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "44090" && mwValue = "102.2")
		{
            newReacLine := "&REAC FUEL='Solvent (Nefras 130/150)' HEAT_OF_COMBUSTION=44090 C=6.44686779167117 H=7.29213132670738 O=1.08870175066646 MW_OTHER=36.46094 CO_YIELD=0.269 SOOT_YIELD=0.0166666666666667 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.19355")
		{
            newReacLine := "&REAC FUEL='Spalnye zaly (pomeshheniya vremennogo prebyvaniya)' HEAT_OF_COMBUSTION=13800 C=0.632259306694422 H=17.2528521857836 O=3.81196323643563 OTHER=0.0334799294806991 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.0310344827586207 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16700" && mwValue = "87.24592")
		{
            newReacLine := "&REAC FUEL='Sportzal' HEAT_OF_COMBUSTION=16700 C=1.99123537785576 H=25.2853524689441 O=2.36531815592534 MW_OTHER=36.46094 CO_YIELD=0.063 SOOT_YIELD=0.00701149425287356 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "26400" && mwValue = "87.17123")
		{
            newReacLine := "&REAC FUEL='Stadion' HEAT_OF_COMBUSTION=26400 C=4.02503600719998 H=11.1753055015559 O=1.72279541030369 MW_OTHER=36.46094 CO_YIELD=0.127 SOOT_YIELD=0.00896551724137931 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.16459")
		{
            newReacLine := "&REAC FUEL='Stolovaya' HEAT_OF_COMBUSTION=13800 C=2.61966863380592 H=10.9845790894423 O=2.75671288009136 OTHER=0.0143437755581727 MW_OTHER=36.46094 CO_YIELD=0.0022 SOOT_YIELD=0.00942528735632184 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "31700" && mwValue = "104.323")
		{
            newReacLine := "&REAC FUEL='Stoyanka legkovyx avtomobilej' HEAT_OF_COMBUSTION=31700 C=3.92459518673909 H=25.2553799741117 O=1.9114720577325 OTHER=0.0314734891640205 MW_OTHER=36.46094 CO_YIELD=0.097 SOOT_YIELD=0.0559770114942529 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "31700" && mwValue = "104.323")
		{
            newReacLine := "&REAC FUEL='Stoyanka legkovyx avtomobilej s dvuxurovnevym xraneniem' HEAT_OF_COMBUSTION=31700 C=3.92459518673909 H=25.2553799741117 O=1.9114720577325 OTHER=0.0314734891640205 MW_OTHER=36.46094 CO_YIELD=0.097 SOOT_YIELD=0.0559770114942529 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "20710" && mwValue = "87.18047")
		{
            newReacLine := "&REAC FUEL='Tara' HEAT_OF_COMBUSTION=20710 C=2.34221462264701 H=13.8891821055691 O=2.79062596270668 OTHER=0.0109988980536432 MW_OTHER=36.46094 CO_YIELD=0.094 SOOT_YIELD=0.017816091954023 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "20900" && mwValue = "104.3331")
		{
            newReacLine := "&REAC FUEL='Tekstolit, karbolit' HEAT_OF_COMBUSTION=20900 C=1.41959477548881 H=28.7195853364237 O=3.61087021286701 OTHER=0.0154521178005833 MW_OTHER=36.46094 CO_YIELD=0.0556 SOOT_YIELD=0.0375862068965517 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "34600" && mwValue = "104.3137")
		{
            newReacLine := "&REAC FUEL='Telefonnyj kabel TPV' HEAT_OF_COMBUSTION=34600 C=3.1520515852028 H=24.1891482625847 O=2.52802309148436 OTHER=0.0446311510345043 MW_OTHER=36.46094 CO_YIELD=0.124 SOOT_YIELD=0.0639080459770115 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "40900" && mwValue = "92.01662")
		{
            newReacLine := "&REAC FUEL='Toluol' HEAT_OF_COMBUSTION=40900 C=8.66452529210423 H=2.18339284863942 O=-0.890728448223683 MW_OTHER=36.46094 CO_YIELD=0.148 SOOT_YIELD=0.0645977011494253 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "41900" && mwValue = "303.9111")
		{
            newReacLine := "&REAC FUEL='Toplivo' HEAT_OF_COMBUSTION=41900 C=6.85783241418118 H=14.6554890267393 O=12.9237272476138 MW_OTHER=36.46094 CO_YIELD=0.122 SOOT_YIELD=0.0279310344827586 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "41900" && mwValue = "303.9111")
		{
            newReacLine := "&REAC FUEL='Turbinnoe maslo' HEAT_OF_COMBUSTION=41900 C=6.85783241418118 H=14.6554890267393 O=12.9237272476138 MW_OTHER=36.46094 CO_YIELD=0.122 SOOT_YIELD=0.0279310344827586 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "29000" && mwValue = "87.17929")
		{
            newReacLine := "&REAC FUEL='Uborochnyj inventar' HEAT_OF_COMBUSTION=29000 C=5.44561894924386 H=6.13767282019746 O=0.89032262283766 OTHER=0.0368218994353958 MW_OTHER=36.46094 CO_YIELD=0.269 SOOT_YIELD=0.00919540229885057 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "23540" && mwValue = "87.20414")
		{
            newReacLine := "&REAC FUEL='Upakovka' HEAT_OF_COMBUSTION=23540 C=1.83633435808601 H=18.2698629639707 O=2.90078993984157 OTHER=0.00884934173392129 MW_OTHER=36.46094 CO_YIELD=0.112 SOOT_YIELD=0.0197701149425287 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "18400" && mwValue = "87.18266")
		{
            newReacLine := "&REAC FUEL='Fanera' HEAT_OF_COMBUSTION=18400 C=1.53232549594455 H=14.8378361217185 O=3.3640455271711 MW_OTHER=36.46094 CO_YIELD=0.121 SOOT_YIELD=0.0119540229885057 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16100" && mwValue = "87.15811")
		{
            newReacLine := "&REAC FUEL='Fanera (proizvodstvo)' HEAT_OF_COMBUSTION=16100 C=2.37992779151682 H=10.0776822886765 O=3.02610175906892 MW_OTHER=36.46094 CO_YIELD=0.072 SOOT_YIELD=0.00925287356321839 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13357")
		{
            newReacLine := "&REAC FUEL='Xvojnye + listvennye drevesnye strojmaterialy' HEAT_OF_COMBUSTION=13800 C=3.2301635137914 H=5.32020831662923 O=2.68601288320423 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00655172413793103 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "13800" && mwValue = "87.13356")
		{
            newReacLine := "&REAC FUEL='Xvojnye drevesnye strojmaterialy' HEAT_OF_COMBUSTION=13800 C=3.2334678065282 H=5.31612739886991 O=2.68378882893718 MW_OTHER=36.46094 CO_YIELD=0.024 SOOT_YIELD=0.00701149425287356 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "15700" && mwValue = "87.29669")
		{
            newReacLine := "&REAC FUEL='Xlopok + kapron' HEAT_OF_COMBUSTION=15700 C=2.11380738141034 H=33.8476841565178 O=1.73706194802261 MW_OTHER=36.46094 CO_YIELD=0.012 SOOT_YIELD=0.000494252873563218 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16700" && mwValue = "87.18314")
		{
            newReacLine := "&REAC FUEL='Xlopok v tyukax' HEAT_OF_COMBUSTION=16700 C=1.1617035071687 H=15.1641303964484 O=3.62174419646093 MW_OTHER=36.46094 CO_YIELD=0.0052 SOOT_YIELD=6.89655172413793E-05 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "16400" && mwValue = "87.24904")
		{
            newReacLine := "&REAC FUEL='Xlopok razryxlennyj' HEAT_OF_COMBUSTION=16400 C=1.14672157823222 H=26.392114226885 O=2.92976258663987 MW_OTHER=36.46094 CO_YIELD=0.0052 SOOT_YIELD=6.89655172413793E-05 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "14500" && mwValue = "87.15314")
		{
            newReacLine := "&REAC FUEL='Xranilishha bibliotek' HEAT_OF_COMBUSTION=14500 C=2.53955051032171 H=9.12087175057684 O=2.96624057122142 MW_OTHER=36.46094 CO_YIELD=0.0974 SOOT_YIELD=0.00568965517241379 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "21800" && mwValue = "87.21016")
		{
            newReacLine := "&REAC FUEL='SHerst' HEAT_OF_COMBUSTION=21800 C=1.60010644021707 H=19.4740259808878 O=3.02280788242192 MW_OTHER=36.46094 CO_YIELD=0.0153 SOOT_YIELD=0.0188505747126437 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "25000" && mwValue = "104.3435")
		{
            newReacLine := "&REAC FUEL='SHerst' HEAT_OF_COMBUSTION=21800 C=1.60010644021707 H=19.4740259808878 O=3.02280788242192 MW_OTHER=36.46094 CO_YIELD=0.0153 SOOT_YIELD=0.0188505747126437 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "25000" && mwValue = "104.3435")
		{
            newReacLine := "&REAC FUEL='Elektrokabel AVVG' HEAT_OF_COMBUSTION=25000 C=1.97791176252341 H=30.020081302469 O=2.98589581409285 OTHER=0.0701138190622622 MW_OTHER=36.46094 CO_YIELD=0.109 SOOT_YIELD=0.0729885057471264 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "36400" && mwValue = "104.3129")
		{
            newReacLine := "&REAC FUEL='Elektrokabel APVG' HEAT_OF_COMBUSTION=36400 C=3.10148548398592 H=24.0651959991344 O=2.57113454449609 OTHER=0.0457751884619541 MW_OTHER=36.46094 CO_YIELD=0.15 SOOT_YIELD=0.0467816091954023 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "27200" && mwValue = "6.997")
		{
            newReacLine := "&REAC FUEL='Elektrotexnika, elektronika' HEAT_OF_COMBUSTION=27200 C=0.0863956954681189 H=1.90425341872297 O=0.224080220213023 OTHER=0.0124737595904 MW_OTHER=36.46094 CO_YIELD=0.0552 SOOT_YIELD=0.017816091954023 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		else if (heatValue = "27500" && mwValue = "46.02911")
		{
            newReacLine := "&REAC FUEL='Etilovyj spirt' HEAT_OF_COMBUSTION=27500 C=2.50285271164916 H=5.86405973106822 O=0.628615868472419 MW_OTHER=36.46094 CO_YIELD=0.269 SOOT_YIELD=0.00919540229885057 VISIBILITY_FACTOR=2.38 /"

            modifiedContent := StrReplace(fileContent, reLine, newReacLine)

            FileDelete, %filePath%
            FileAppend, %modifiedContent%, %filePath%
            ToolTip, &REAC line replaced successfully.
			Sleep, 500
			ToolTip
        }
		
		
		
		
		else
		{
            ToolTip, % "Value conditions not met. HEAT_OF_COMBUSTION: " heatValue ", MW: " mwValue
			Sleep, 500
			ToolTip
        }
    }
	else
	{
        ToolTip, &REAC line not found.
		Sleep, 500
		ToolTip
    }
}
/*
filePath := "E:\ЗАДАЧИ\(503) Ф3.1, Ленинградская область г Кингисепп ул Большая Советская 28 (РПР)\Ленинградская область г Кингисепп ул Большая Советская 28\Results\ffdb7ff7\fds\ffdb7ff7_nfs.fds"
Process_Reac_Line_to_FDS5(filePath)
MsgBox, Done!
*/