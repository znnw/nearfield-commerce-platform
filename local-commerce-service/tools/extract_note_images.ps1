param(
    [string]$OutputDirectory = "target\imported-note-images"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$outputPath = Join-Path (Get-Location) $OutputDirectory
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$sources = @{
    Review = "C:\Users\翼纸倾\AppData\Local\Temp\codex-clipboard-9ecae79b-7655-4b3b-b7f7-d5f349024a46.png"
    Foods = "C:\Users\翼纸倾\AppData\Local\Temp\codex-clipboard-3d99f8ea-2f25-4ecc-a9c8-08a728b15753.png"
    Restaurants = "C:\Users\翼纸倾\AppData\Local\Temp\codex-clipboard-c694fcbd-d176-4256-aaba-7b685bb82f6f.png"
    Feed = "C:\Users\翼纸倾\AppData\Local\Temp\codex-clipboard-d62602f1-c4b6-4df0-8020-c97109ee9e0d.png"
}

$crops = @(
    @{ Source = "Review"; Name = "gym-review-01.jpg"; X = 70; Y = 176; W = 460; H = 448 },
    @{ Source = "Review"; Name = "gym-review-02.jpg"; X = 544; Y = 176; W = 462; H = 448 },
    @{ Source = "Review"; Name = "gym-review-03.jpg"; X = 1020; Y = 176; W = 462; H = 448 },
    @{ Source = "Review"; Name = "gym-review-04.jpg"; X = 70; Y = 826; W = 460; H = 448 },
    @{ Source = "Review"; Name = "gym-review-05.jpg"; X = 544; Y = 826; W = 462; H = 448 },
    @{ Source = "Review"; Name = "gym-review-06.jpg"; X = 1020; Y = 826; W = 462; H = 448 },

    @{ Source = "Foods"; Name = "food-longjing-shrimp.jpg"; X = 51; Y = 67; W = 406; H = 249 },
    @{ Source = "Foods"; Name = "food-west-lake-fish.jpg"; X = 482; Y = 67; W = 406; H = 249 },
    @{ Source = "Foods"; Name = "food-dongpo-pork.jpg"; X = 912; Y = 67; W = 406; H = 249 },
    @{ Source = "Foods"; Name = "food-pianer-noodles.jpg"; X = 51; Y = 628; W = 406; H = 250 },
    @{ Source = "Foods"; Name = "food-beggar-chicken.jpg"; X = 482; Y = 628; W = 406; H = 250 },
    @{ Source = "Foods"; Name = "food-fish-soup.jpg"; X = 912; Y = 628; W = 406; H = 250 },

    @{ Source = "Restaurants"; Name = "restaurant-tea-garden.jpg"; X = 49; Y = 62; W = 404; H = 250 },
    @{ Source = "Restaurants"; Name = "restaurant-canal-boat.jpg"; X = 471; Y = 62; W = 403; H = 250 },
    @{ Source = "Restaurants"; Name = "restaurant-fried-balls.jpg"; X = 889; Y = 62; W = 402; H = 250 },
    @{ Source = "Restaurants"; Name = "restaurant-soup-dumplings.jpg"; X = 49; Y = 522; W = 404; H = 251 },
    @{ Source = "Restaurants"; Name = "restaurant-fish-dish.jpg"; X = 471; Y = 522; W = 403; H = 251 },
    @{ Source = "Restaurants"; Name = "restaurant-roast-duck.jpg"; X = 889; Y = 522; W = 402; H = 251 },

    @{ Source = "Feed"; Name = "feed-bakery-collage.jpg"; X = 40; Y = 66; W = 264; H = 416 },
    @{ Source = "Feed"; Name = "feed-angel-statue.jpg"; X = 341; Y = 35; W = 266; H = 434 },
    @{ Source = "Feed"; Name = "feed-autumn-temple.jpg"; X = 748; Y = 50; W = 270; H = 357 },
    @{ Source = "Feed"; Name = "feed-gym.jpg"; X = 1057; Y = 61; W = 318; H = 332 },
    @{ Source = "Feed"; Name = "feed-fried-chicken.jpg"; X = 1415; Y = 25; W = 364; H = 370 },
    @{ Source = "Feed"; Name = "feed-pastry.jpg"; X = 42; Y = 638; W = 262; H = 407 },
    @{ Source = "Feed"; Name = "feed-lotus-root.jpg"; X = 342; Y = 638; W = 265; H = 410 },
    @{ Source = "Feed"; Name = "feed-pancake.jpg"; X = 1058; Y = 605; W = 275; H = 345 },
    @{ Source = "Feed"; Name = "feed-noodles.jpg"; X = 1415; Y = 645; W = 310; H = 305 }
)

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" } |
    Select-Object -First 1
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters 1
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality,
    [long]90
)

foreach ($group in $crops | Group-Object Source) {
    $sourceImage = [System.Drawing.Bitmap]::new($sources[$group.Name])
    try {
        foreach ($crop in $group.Group) {
            $rect = [System.Drawing.Rectangle]::new($crop.X, $crop.Y, $crop.W, $crop.H)
            $bitmap = $sourceImage.Clone($rect, $sourceImage.PixelFormat)
            try {
                $target = Join-Path $outputPath $crop.Name
                $bitmap.Save($target, $jpegCodec, $encoderParams)
            }
            finally {
                $bitmap.Dispose()
            }
        }
    }
    finally {
        $sourceImage.Dispose()
    }
}

$encoderParams.Dispose()
Get-ChildItem $outputPath -File | Select-Object Name, Length
