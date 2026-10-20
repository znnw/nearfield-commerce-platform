param(
    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)

$palettes = @{
    "a" = @{
        bg = "#f4f6f2"; wall = "#e5f1ed"; floor = "#d9e2dd"; line = "#bfd0c9";
        primary = "#126c63"; secondary = "#e26745"; highlight = "#e9b949";
        ink = "#182420"; soft = "#ffffff"; muted = "#8da39b"
    }
    "b" = @{
        bg = "#182420"; wall = "#233a34"; floor = "#111a17"; line = "#3d574f";
        primary = "#4aa89b"; secondary = "#e26745"; highlight = "#e9b949";
        ink = "#f4f6f2"; soft = "#25332f"; muted = "#91aaa2"
    }
}

$scenes = @{
    hair = @'
<rect x="90" y="62" width="265" height="265" rx="18" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="112" y="84" width="221" height="221" rx="12" fill="{{soft}}" opacity=".74"/>
<circle cx="222" cy="175" r="52" fill="{{highlight}}" opacity=".85"/>
<path d="M120 316h205" stroke="{{line}}" stroke-width="4"/>
<rect x="175" y="285" width="96" height="24" rx="10" fill="{{ink}}"/>
<rect x="193" y="309" width="60" height="76" rx="18" fill="{{secondary}}"/>
<path d="M205 385v58M241 385v58M186 443h34M226 443h34" stroke="{{ink}}" stroke-width="8" stroke-linecap="round"/>
<rect x="445" y="92" width="255" height="225" rx="18" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="478" y="124" width="85" height="152" rx="8" fill="{{primary}}" opacity=".24"/>
<rect x="578" y="124" width="85" height="152" rx="8" fill="{{primary}}" opacity=".24"/>
<path d="M470 310h190" stroke="{{line}}" stroke-width="4"/>
<circle cx="520" cy="82" r="12" fill="{{highlight}}"/>
<path d="M520 94v34" stroke="{{ink}}" stroke-width="4"/>
<circle cx="620" cy="82" r="12" fill="{{highlight}}"/>
<path d="M620 94v34" stroke="{{ink}}" stroke-width="4"/>
<path d="M365 388c24-33 63-47 90-27-23 31-61 47-90 27Z" fill="{{primary}}"/>
<path d="M382 371c18 5 34 12 50 24" stroke="{{soft}}" stroke-width="4" stroke-linecap="round"/>
<rect x="86" y="403" width="650" height="7" rx="3.5" fill="{{line}}"/>
'@
    gym = @'
<rect x="70" y="68" width="660" height="260" rx="18" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="94" y="92" width="260" height="212" rx="12" fill="{{primary}}" opacity=".18"/>
<path d="M114 272 250 96M182 304 318 128" stroke="{{soft}}" stroke-width="6" opacity=".72"/>
<rect x="405" y="250" width="210" height="18" rx="9" fill="{{ink}}"/>
<path d="M432 268v64M588 268v64M420 332h35M565 332h35" stroke="{{ink}}" stroke-width="8" stroke-linecap="round"/>
<circle cx="382" cy="258" r="36" fill="{{secondary}}"/>
<circle cx="638" cy="258" r="36" fill="{{secondary}}"/>
<path d="M350 258h32M606 258h32" stroke="{{ink}}" stroke-width="9" stroke-linecap="round"/>
<rect x="142" y="168" width="112" height="16" rx="8" fill="{{ink}}"/>
<circle cx="130" cy="176" r="24" fill="{{highlight}}"/>
<circle cx="266" cy="176" r="24" fill="{{highlight}}"/>
<path d="M108 384h584M118 404h564" stroke="{{line}}" stroke-width="5" stroke-linecap="round"/>
<rect x="96" y="430" width="130" height="18" rx="9" fill="{{primary}}"/>
<rect x="242" y="430" width="86" height="18" rx="9" fill="{{highlight}}"/>
'@
    massage = @'
<rect x="88" y="88" width="624" height="235" rx="18" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="138" y="218" width="360" height="58" rx="22" fill="{{soft}}" stroke="{{line}}" stroke-width="3"/>
<path d="M174 218v-34c0-20 16-36 36-36h180c20 0 36 16 36 36v34" fill="{{primary}}" opacity=".22"/>
<circle cx="238" cy="183" r="12" fill="{{highlight}}"/>
<circle cx="274" cy="183" r="12" fill="{{highlight}}"/>
<circle cx="310" cy="183" r="12" fill="{{highlight}}"/>
<rect x="548" y="186" width="118" height="92" rx="10" fill="{{secondary}}" opacity=".22"/>
<path d="M570 240c18-28 37-28 54 0 17-28 35-28 52 0" stroke="{{primary}}" stroke-width="5" fill="none" stroke-linecap="round"/>
<path d="M560 112c35 16 72 16 108 0" stroke="{{line}}" stroke-width="5" stroke-linecap="round"/>
<path d="M614 112v56" stroke="{{ink}}" stroke-width="4"/>
<circle cx="614" cy="184" r="24" fill="{{highlight}}"/>
<path d="M110 365h580" stroke="{{line}}" stroke-width="5"/>
<rect x="106" y="400" width="122" height="20" rx="10" fill="{{primary}}"/>
<rect x="240" y="400" width="90" height="20" rx="10" fill="{{secondary}}"/>
<path d="M630 398c-22-30-20-69 3-94 23 24 29 63 8 94Z" fill="{{primary}}" opacity=".72"/>
'@
    beauty = @'
<rect x="82" y="72" width="636" height="274" rx="20" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="128" y="236" width="360" height="58" rx="20" fill="{{soft}}" stroke="{{line}}" stroke-width="3"/>
<path d="M172 236v-34c0-24 19-43 43-43h188c24 0 43 19 43 43v34" fill="{{secondary}}" opacity=".2"/>
<rect x="542" y="122" width="120" height="170" rx="16" fill="{{primary}}" opacity=".2"/>
<circle cx="602" cy="172" r="28" fill="{{highlight}}" opacity=".88"/>
<path d="M602 204v55M580 238h44" stroke="{{primary}}" stroke-width="6" stroke-linecap="round"/>
<rect x="112" y="112" width="24" height="82" rx="10" fill="{{primary}}"/>
<rect x="150" y="96" width="20" height="98" rx="9" fill="{{secondary}}"/>
<rect x="184" y="122" width="16" height="72" rx="8" fill="{{highlight}}"/>
<path d="M108 378h582" stroke="{{line}}" stroke-width="5"/>
<path d="M670 394c-24-38-18-83 10-112 25 33 27 75 3 112Z" fill="{{primary}}" opacity=".7"/>
<circle cx="118" cy="416" r="10" fill="{{secondary}}"/>
<circle cx="150" cy="404" r="7" fill="{{highlight}}"/>
<circle cx="178" cy="424" r="5" fill="{{primary}}"/>
'@
    nail = @'
<rect x="74" y="80" width="652" height="260" rx="20" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="214" y="210" width="372" height="36" rx="18" fill="{{ink}}"/>
<path d="M250 246v78M550 246v78" stroke="{{ink}}" stroke-width="9" stroke-linecap="round"/>
<path d="M320 174c18-25 49-25 67 0M410 174c18-25 49-25 67 0" fill="none" stroke="{{primary}}" stroke-width="8" stroke-linecap="round"/>
<rect x="286" y="96" width="28" height="70" rx="10" fill="{{secondary}}"/>
<rect x="326" y="82" width="24" height="84" rx="9" fill="{{highlight}}"/>
<rect x="362" y="104" width="20" height="62" rx="8" fill="{{primary}}"/>
<circle cx="604" cy="144" r="38" fill="{{highlight}}" opacity=".9"/>
<path d="M604 182v28" stroke="{{ink}}" stroke-width="5"/>
<path d="M128 176h42M128 198h62M128 220h34" stroke="{{line}}" stroke-width="7" stroke-linecap="round"/>
<path d="M106 380h588" stroke="{{line}}" stroke-width="5"/>
<path d="M612 398c-18-31-13-66 10-89 20 25 22 59 4 89Z" fill="{{primary}}" opacity=".72"/>
'@
    playground = @'
<rect x="76" y="66" width="648" height="292" rx="22" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<path d="M160 294V146h122l-98 148" fill="{{primary}}" opacity=".78"/>
<path d="M180 294V168h78l-64 126" fill="{{soft}}" opacity=".84"/>
<path d="M342 294V112h16v-36h72v36h16v182" fill="{{secondary}}" opacity=".72"/>
<rect x="332" y="104" width="124" height="38" rx="18" fill="{{highlight}}"/>
<path d="M470 306c0-46 32-82 74-82s74 36 74 82Z" fill="{{primary}}" opacity=".22"/>
<circle cx="506" cy="272" r="15" fill="{{secondary}}"/>
<circle cx="542" cy="286" r="17" fill="{{highlight}}"/>
<circle cx="580" cy="270" r="14" fill="{{primary}}"/>
<rect x="112" y="348" width="576" height="20" rx="10" fill="{{line}}"/>
<rect x="164" y="394" width="62" height="62" rx="10" fill="{{secondary}}" opacity=".82"/>
<rect x="242" y="410" width="50" height="46" rx="8" fill="{{highlight}}" opacity=".9"/>
<rect x="560" y="392" width="76" height="64" rx="12" fill="{{primary}}" opacity=".55"/>
'@
    bar = @'
<rect x="70" y="58" width="660" height="286" rx="20" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="106" y="98" width="258" height="150" rx="12" fill="{{primary}}" opacity=".18"/>
<path d="M126 222h218M126 176h218M126 130h218" stroke="{{line}}" stroke-width="5"/>
<rect x="148" y="148" width="20" height="58" rx="5" fill="{{secondary}}"/>
<rect x="190" y="130" width="18" height="76" rx="5" fill="{{highlight}}"/>
<rect x="230" y="156" width="22" height="50" rx="5" fill="{{primary}}"/>
<rect x="274" y="140" width="18" height="66" rx="5" fill="{{soft}}" opacity=".8"/>
<rect x="426" y="250" width="250" height="24" rx="12" fill="{{ink}}"/>
<path d="M450 274v55M650 274v55M430 329h42M628 329h42" stroke="{{ink}}" stroke-width="8" stroke-linecap="round"/>
<circle cx="510" cy="206" r="22" fill="{{secondary}}"/>
<path d="M510 228v22" stroke="{{ink}}" stroke-width="5"/>
<circle cx="600" cy="206" r="22" fill="{{secondary}}"/>
<path d="M600 228v22" stroke="{{ink}}" stroke-width="5"/>
<rect x="74" y="382" width="652" height="7" rx="3.5" fill="{{line}}"/>
<path d="M690 390c-22-31-18-70 7-96 22 28 25 65 5 96Z" fill="{{primary}}" opacity=".7"/>
'@
    party = @'
<rect x="74" y="64" width="652" height="286" rx="22" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<path d="M212 278v-74c0-22 18-40 40-40h104c22 0 40 18 40 40v74" fill="{{primary}}" opacity=".34"/>
<rect x="224" y="278" width="160" height="42" rx="16" fill="{{primary}}" opacity=".62"/>
<rect x="246" y="322" width="12" height="42" rx="6" fill="{{ink}}"/>
<rect x="350" y="322" width="12" height="42" rx="6" fill="{{ink}}"/>
<rect x="500" y="250" width="118" height="82" rx="14" fill="{{ink}}"/>
<circle cx="522" cy="272" r="9" fill="{{secondary}}"/>
<circle cx="558" cy="272" r="9" fill="{{highlight}}"/>
<path d="M548 198v52" stroke="{{line}}" stroke-width="4"/>
<circle cx="548" cy="174" r="24" fill="{{highlight}}"/>
<path d="M548 150v48M524 174h48M531 157l34 34M565 157l-34 34" stroke="{{soft}}" stroke-width="3" opacity=".8"/>
<circle cx="142" cy="158" r="20" fill="{{secondary}}"/>
<path d="M142 178c0 34 10 54 32 68" fill="none" stroke="{{line}}" stroke-width="3"/>
<circle cx="182" cy="132" r="15" fill="{{highlight}}"/>
<path d="M182 147c0 47 18 76 48 96" fill="none" stroke="{{line}}" stroke-width="3"/>
<path d="M402 118l10 22 22 10-22 10-10 22-10-22-22-10 22-10Z" fill="{{secondary}}"/>
<path d="M630 112l7 15 15 7-15 7-7 15-7-15-15-7 15-7Z" fill="{{primary}}"/>
<rect x="100" y="378" width="600" height="7" rx="3.5" fill="{{line}}"/>
'@
    karaoke = @'
<rect x="70" y="62" width="660" height="282" rx="22" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="148" y="102" width="282" height="162" rx="16" fill="{{ink}}" opacity=".92"/>
<rect x="178" y="132" width="222" height="102" rx="10" fill="{{primary}}" opacity=".42"/>
<circle cx="550" cy="148" r="26" fill="{{highlight}}"/>
<path d="M550 174v58" stroke="{{ink}}" stroke-width="6"/>
<path d="M536 208h28" stroke="{{ink}}" stroke-width="8" stroke-linecap="round"/>
<rect x="478" y="246" width="144" height="68" rx="14" fill="{{ink}}"/>
<circle cx="510" cy="278" r="12" fill="{{secondary}}"/>
<circle cx="562" cy="278" r="12" fill="{{highlight}}"/>
<path d="M410 154c26 8 40 25 43 49-20-3-35-16-43-49ZM410 226c26-8 40-25 43-49-20 3-35 16-43 49Z" fill="{{secondary}}" opacity=".8"/>
<path d="M654 104c-24 28-28 56-12 84" fill="none" stroke="{{primary}}" stroke-width="7" stroke-linecap="round"/>
<rect x="94" y="372" width="612" height="7" rx="3.5" fill="{{line}}"/>
'@
    dessert = @'
<rect x="74" y="76" width="652" height="258" rx="20" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<rect x="108" y="108" width="238" height="194" rx="14" fill="{{soft}}" opacity=".82"/>
<path d="M138 240h176l-20-74H158Z" fill="{{highlight}}"/>
<path d="M160 180c22-28 54-38 90-22 22 10 35 27 38 48H160" fill="{{secondary}}" opacity=".72"/>
<circle cx="224" cy="144" r="12" fill="{{primary}}"/>
<path d="M224 132v-18" stroke="{{primary}}" stroke-width="4"/>
<rect x="418" y="216" width="238" height="90" rx="14" fill="{{ink}}"/>
<path d="M448 216v-38h92v38" fill="{{primary}}" opacity=".36"/>
<circle cx="494" cy="166" r="26" fill="{{soft}}" stroke="{{line}}" stroke-width="4"/>
<path d="M474 166h40" stroke="{{secondary}}" stroke-width="5"/>
<rect x="590" y="170" width="36" height="72" rx="10" fill="{{secondary}}"/>
<path d="M608 170v-34" stroke="{{ink}}" stroke-width="5"/>
<path d="M256 310h340" stroke="{{line}}" stroke-width="6" stroke-linecap="round"/>
<path d="M96 390h608" stroke="{{line}}" stroke-width="5"/>
'@
    travel = @'
<rect x="60" y="56" width="680" height="296" rx="24" fill="{{wall}}" stroke="{{line}}" stroke-width="4"/>
<circle cx="640" cy="130" r="42" fill="{{highlight}}" opacity=".88"/>
<path d="M112 292 244 132l104 118 78-92 166 134Z" fill="{{primary}}" opacity=".72"/>
<path d="M180 292 268 190l80 82 54-64 92 84Z" fill="{{soft}}" opacity=".82"/>
<path d="M96 308c94-28 184-28 274 0s178 28 334 0v62H96Z" fill="{{primary}}" opacity=".28"/>
<path d="M330 328c40-12 80-8 118 12l-18 18c-32-14-60-18-84-12Z" fill="{{secondary}}"/>
<path d="M446 330v34" stroke="{{ink}}" stroke-width="4"/>
<path d="M138 300c-16-32-8-62 20-86 18 28 20 58 0 86Z" fill="{{primary}}"/>
<path d="M654 300c-16-32-8-62 20-86 18 28 20 58 0 86Z" fill="{{primary}}"/>
<path d="M78 404h644" stroke="{{line}}" stroke-width="5"/>
'@
}

foreach ($category in $scenes.Keys) {
    foreach ($variant in "a", "b") {
        $palette = $palettes[$variant]
        $content = $scenes[$category]
        foreach ($key in $palette.Keys) {
            $content = $content.Replace("{{$key}}", $palette[$key])
        }
        $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" role="img">
  <rect width="800" height="500" fill="$($palette.bg)"/>
  <path d="M0 344h800v156H0z" fill="$($palette.floor)"/>
  <path d="M0 344h800" stroke="$($palette.line)" stroke-width="2"/>
  $content
</svg>
"@
        $path = Join-Path $OutputDirectory "$category-$variant.svg"
        [System.IO.File]::WriteAllText($path, $svg, $utf8)
    }
}

Write-Output "generated=$($scenes.Count * 2) directory=$OutputDirectory"
