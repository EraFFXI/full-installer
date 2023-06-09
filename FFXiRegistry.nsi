
# Modified from reg2nsis output.

############################### reg2nsis begin #################################
# This NSIS-script was generated by the Reg2Nsis utility                       #
# Author  : Artem Zankovich                                                    #
# URL     : http://aarrtteemm.nm.ru                                            #
# Usage   : You can freely inserts this into your setup script as inline text  #
#           or include file with the help of !include directive.               #
#           Please don't remove this header.                                   #
################################################################################

!include "LogicLib.nsh"

WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder" "CommonFilesFolder" "$COMMONFILES\"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\InstallFolder" "0001" "$INSTDIR\SquareEnix\FINAL FANTASY XI"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\InstallFolder" "0002" "$INSTDIR\SquareEnix\TetraMaster"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\InstallFolder" "1000" "$INSTDIR\SquareEnix\PlayOnlineViewer"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0042" "$INSTDIR\SquareEnix\FINAL FANTASY XI"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\Interface" "0001" "130b5023"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\Interface" "0002" "1304d3ed"
WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\Interface" "1000" "1304d1e8"

${If} $OverwriteRegistry == "true"
    WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\Interface" "" ""
    WriteRegBin HKEY_LOCAL_MACHINE "$RegFolder\Product" "0001" 9741e0849e6dc5ec1220cd8c1ecd9649be988450ab9a402c58fbfb50fecae9f3bad2df087753f81d1f33e92a8e4a2faa04dff98ee20508a30fb501134eda95f3f029a5795fa83626a451c3008c52772a1ff31c0c7311d737b1f2f53375887d091a55611511ec3561d55f3a2f252171c73d2eeb09041b801bf03e3cf029869d844d0870d6453da92ee5e03acea1c93a8996abe96dddc6149b648ad02e37ab8767c61d252140618ffa22ac270845ff4419f57670816dd860827536055e29b11463260f64617e7b3c5df923688c664d38c15cfd5b967097cc2022a0135fba2df6589d4fe22e4db2e596903eb45c8a8f30780b29b30ec5e0295da24c6e9168a0590ab762f78359aa022b321feedf8d5e05da9eb59d59625389e5a8c63ba02623705b
    WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix" "" ""
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0000" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0001" $NativeWidth
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0002" $NativeHeight
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0003" $NativeWidth
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0004" $NativeHeight
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0007" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0011" 0x2
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0017" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0018" 0x2
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0019" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0020" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0021" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0022" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0023" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0024" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0028" 0x3dcccccd
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0029" 0x14
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0030" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0031" 0x3bc49ba6
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0032" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0033" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0034" 0x3
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0035" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0036" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0037" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0038" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0039" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0040" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0041" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0043" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0044" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "0045" 0x0
    WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "padmode000" "1,0,1,1,0,0"
    WriteRegBin HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "bFirst" 00
    WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\FinalFantasyXI" "padsin000" "4,6,11,7,10,2,0,1,3,8,-1,-1,9,33,33,32,32,37,37,34,34,41,41,40,40,5,-1"
    WriteRegBin HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer" "SPS000" cb4d6c8782b1168c8812f731359e44a3651424a15a7f06c018cf589f7e5cb3c4e614d86383deb1a00d599bff674928832c1b79fd121da257578176ceddda2d1c783577e8bd64bd2ab76dbb629ed1aaac7e4ef36add80dac9cae96a3468279d528b2a1d58c1a4e5bda5e058e8b9f7dd1ed11480195dec0364ccb006d181d4762cba10c0212bf689087906e6108ba10ed52c101c53b04b80f6a968f379d642e05aee67951984f617d4c861d716025742347d6e61fb39224e4f7cc6d3bac82cd8f87628761eba3bac36252bd822ae941edd13f5bbc2fdbc95393f880362a4f20823f00d274919a14eea80a8162e78f3b9523e774f20a0791d18998c06f8768c2719648325922cb55498773a1333d3c98a9631f8f8c359f32ba6051fe88f598be0a62528a5def6989456bd368b22294361cecee572d0fe4cbd515a66f87fcf8d551face55aef61e757d8d59bb4729c34d8941aea9da1108707c11d9d4ef0bd5bdb49bd8ad8043d5764f788c66ed63c85d48f5710b6738680dd20b36d609227bd3879dcf3798befb675dec62d97b8cc03a7444745818a07990a080028651994363e055ebff6dd175d849111b936c223911f1106167bc6cb7dc8eeada33ebf6aa0d5b48723182a4c225c1ed746ebf1f6d1e8d17dc1c8ba1704febe4892c6f73e592b1aa854561cf8f0dddb9d3d38638af125ac8804daf4b7f1cdb56e54a7bef55742db78c877de5378ab6bb42148b4922fc0fd65aa8277e9edb8fb22fb3d6a9cdba6c6b1977de99b70996f922fe03ae591a644f7760340203fc060df85aa1e3b116dd875effcf965283de71fff538ccfe2a6314bcb192f4b1561b35d0f6e3be2a3f2bba61267f1aedaacf172646ecea3ea86453bf6c26ff3e43eecc4afa13751cd0932ff97f1a672e5f94b830d1efaf99ed6e3509c42ab8cf782628e402a770725df3466aeafd28950d7b72119e03ce9c62d621e609336f128be125acfd9b34c1015810a86e5fb58169bc1154b2c55b19b18abfffc3ce49598441331dc261ef3142f4764ac8405b2b155f5488d6633843e455789cf886c496c22b626cabfc89fb1457251c249d8145ecbeca8a10c4ab32da84dc11717f06b003195bbb896700724adef96e79091d056dc9ed7a971c57b30f9da6d348aa832d3a701bc65229f3fb6d07e896bf58ff8fa1544e10316e377a03c03290f3d74e6b07a858294267454ff02160ff2ea445d88b326360a1596d4d268d683a861eb7df7e2cd6bc022076dd3b3c54f7999dc7bc27584a719c10274e0ff2442217d35df3eb273c34390ba5df19d788cd9b24494d37312e464beb724678c3246748189ffbc28e3d23230bd90ffb0f6b1d52d00c795a09d51d01b1d37d328b6db67f1241198ba934603917bab511c4be06fc72f91d9c385781f24375595de044c1ea52352de97db1c9b9dde9eb8aeb245189f641c4d83021e7624307f4cfa87c0f84ae03ff646d235bf9534ea8257930e966dd540f38cbc50c50314aa058ad3c1a42663fd44fa5fe534d3b276cb8c6267102934e10adbd962413f286eb57f45acd97c6a9d5e02a6afc791d236ee61cdd016c4d13dbbf0a377bec5e084a528da260a9e1c1d0a5ac8dca257692579d16a5191e868079e1b4db65c06bc3dabd7c47af46b32943e01fc6ef1d57fa61e469be45d7cca77f029e046a48f3691aad96f786c7deedf1d9c4d42c861dc8b2b490a1fb924c36e911ec1180b4b293e00766f080edda5139ab757cfa4c43f5b3212967070d735c14a83230e1dbf5508e187f7958ff7dcc8926e8c73771aa70aa4930ba2dd0f304ead9f0d815817b0a3f689b4b4ec08f004f621201dcc41129ff2a495a19f13dc2343c07f1b87fabd2d41b5dbd54542b92f66be72f644c84806896df493eba79b077200d1eede33e46633b00037ec79214a1fb9101c63f7b7165e6e00adbf187cea9771c3da489e8232b09e6b05ff0ffb3439b668a2095d25ec2f10cbe96f9f5aa84f6c0a99f1d63a24f21165d9eaf9e938bdf4a9ae2d7a3f0ec50700aa6b9c21ca46a597b45d213c5b09bc236071e1e7ca432e4d9ceb3e7e805319f547c842b12ed9fbba018478713304c55cbb8b4d986b0301f294436ee38fb1eea82e684329fc147472fc796934e3ce1b7326485cd9d199757c078afb97e5ac06c9cd09e3c0baad9d118f2a7afbb2ac9f1dcee3b14a5d6fac7155f0356239ff104ab27aaad8c03aae86ae9c1debb3ad58741ae7043fe990987a4b03d871bf19e81bcdefdc1c3a8f53bdd6c096a0358280a97855255a1ee500db9f6be31b0a42de932d5d98af66a28f4150f9d2444ac8f985fb217c80f1bd0f7098c9ea47e6a2e64eea87bdfc049dbf09a85955daf70d0fe604ab5bf788cda5784cd1969f34211b99ee1d90c6025118c61d87dd749fc055668d74edd0cdb3946820ab13adf7d514639cadf94820fbefead75781551bd43c1cd75de02cb60e43edc98fbfdfa76f2f6fc8d67c6f7697279da3611ccb492d7c49d2693b39e603c12f0d5b9d50cdfbb02b433f78bf71e8d2c28866898a5ae73e6a791c824d7f755ad4566fa83de203584a84dce8aa4686071fdaa109af6db3af5734baa62cfbb583a7034e071ffee112aeb5b349d3
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer" "FirstBootPlayMovie" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "WindowX" 0x82
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "WindowY" 0x82
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "FullScreen" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "Language" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "PlayAudio" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "PlayOpeningMovie" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "ResetSettings" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "SupportLanguage" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "UseGameController" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "WindowH" 0x1e0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings" "WindowW" 0x280
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "AnchorDown" 0x34
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "AnchorLeft" 0x36
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "AnchorRight" 0x32
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "AnchorUp" 0x30
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "Cancel" 0x2
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "ChrCsrNext" 0x7
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "ChrCsrPrev" 0x6
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "ID" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "Menu" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "Navi" 0x3
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "Ok" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "PageNext" 0x5
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controler" "PagePrev" 0x4
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorDown" 0x34
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorLeft" 0x36
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorRight" 0x32
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "AnchorUp" 0x30
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "Cancel" 0x2
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "ChrCsrNext" 0x7
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "ChrCsrPrev" 0x6
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "ID" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "Menu" 0x0
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "Navi" 0x3
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "Ok" 0x1
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "PageNext" 0x5
    WriteRegDWORD HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\Settings\Controller" "PagePrev" 0x4
    WriteRegStr HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\SystemInfo" "" ""
    WriteRegBin HKEY_LOCAL_MACHINE "$RegFolder\SquareEnix\PlayOnlineViewer\SystemInfo\QCheck" "LastMeasurementTime" ""
${EndIf}

###############################  reg2nsis end  #################################
