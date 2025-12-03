Add-Type -AssemblyName PresentationFramework 
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

# ---------------------------------------------------------
# Initialization
# ---------------------------------------------------------

# Create main window (WPF)
$window = New-Object System.Windows.Window
$window.Title = "YAFAR: Yet Another Fortnite AFK Reminder"
# CORE: Ancho ajustado
$window.Width = 290
# CORE: Altura ajustada
$window.Height = 470
# Restringe la ventana a solo poder cerrarse. Minimizar y Maximizar están deshabilitados.
$window.ResizeMode = "NoResize" 
$window.WindowStartupLocation = "CenterScreen"

# Main Grid
$mainGrid = New-Object System.Windows.Controls.Grid
$window.Content = $mainGrid

# ---------------------------------------------------------
# UI and Styles
# ---------------------------------------------------------

# Background image
$assetsPath = Join-Path (Get-Location) "Assets"
if (-not (Test-Path $assetsPath)) { New-Item -ItemType Directory -Path $assetsPath | Out-Null }
$bgPath = Join-Path $assetsPath "background.png"

if (Test-Path $bgPath) {
    $bgBrush = New-Object System.Windows.Media.ImageBrush
    $imgBg = New-Object System.Windows.Media.Imaging.BitmapImage
    $imgBg.BeginInit()
    $imgBg.UriSource = New-Object System.Uri($bgPath, [System.UriKind]::Absolute)
    $imgBg.EndInit()
    $bgBrush.ImageSource = $imgBg
    $bgBrush.Stretch = "UniformToFill"
    $bgBrush.AlignmentX = "Center"
    $bgBrush.AlignmentY = "Center"
    $mainGrid.Background = $bgBrush
} else {
    $mainGrid.Background = [System.Windows.Media.Brushes]::Black
}

# Semi-transparent black overlay
$overlay = New-Object System.Windows.Shapes.Rectangle
$overlay.Fill = [System.Windows.Media.Brushes]::Black
$overlay.Opacity = 0.5
$overlay.HorizontalAlignment = "Stretch"
$overlay.VerticalAlignment = "Stretch"
$mainGrid.Children.Add($overlay) | Out-Null 

# Content Grid
$grid = New-Object System.Windows.Controls.Grid
$grid.Margin = 20
$mainGrid.Children.Add($grid) | Out-Null 

## Se definen 4 columnas para centrar el input:
$col1 = New-Object System.Windows.Controls.ColumnDefinition; $col1.Width = "*" # Espacio Flexible Izquierda
$col2 = New-Object System.Windows.Controls.ColumnDefinition; $col2.Width = "Auto" # Columna para el input (número)
$col3 = New-Object System.Windows.Controls.ColumnDefinition; $col3.Width = "Auto" # Columna para la etiqueta "Mins"
$col4 = New-Object System.Windows.Controls.ColumnDefinition; $col4.Width = "*" # Espacio Flexible Derecha

$grid.ColumnDefinitions.Add($col1) | Out-Null 
$grid.ColumnDefinitions.Add($col2) | Out-Null 
$grid.ColumnDefinitions.Add($col3) | Out-Null 
$grid.ColumnDefinitions.Add($col4) | Out-Null 

for ($i = 0; $i -lt 10; $i++) {
    $row = New-Object System.Windows.Controls.RowDefinition
    $row.Height = "Auto"
    $grid.RowDefinitions.Add($row) | Out-Null 
}

$fontFamily = "Helvetica"
$foreground = "Yellow"

# Window Icon
$iconPath = Join-Path $assetsPath "logo.ico"
if (Test-Path $iconPath) {
    $window.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create((New-Object System.Uri($iconPath, [System.UriKind]::Absolute)))
}

# ---------------------------------------------------------
# XP Image (Easter Egg Logic)
# ---------------------------------------------------------

# Click counter variable for Easter Egg
$script:xpClickCount = 0

$rickrollUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

$xpPath = Join-Path $assetsPath "xp.png"
if (Test-Path $xpPath) {
    $imgXP = New-Object System.Windows.Controls.Image
    $bmpXP = New-Object System.Windows.Media.Imaging.BitmapImage
    $bmpXP.BeginInit()
    $bmpXP.UriSource = New-Object System.Uri($xpPath, [System.UriKind]::Absolute)
    $bmpXP.CacheOption = "OnLoad"
    $bmpXP.CreateOptions = "IgnoreImageCache"
    $bmpXP.EndInit()
    
    $imgXP.Source = $bmpXP
    $imgXP.HorizontalAlignment = "Center"
    $imgXP.VerticalAlignment = "Top"
    $imgXP.Margin = "0,0,0,10"
    $imgXP.MaxHeight = 96
    $imgXP.MaxWidth = 96
    $imgXP.Stretch = "Uniform"

    $imgXP.Cursor = [System.Windows.Input.Cursors]::Hand
    
    # Mouse click handler for Easter Egg
    $imgXP.Add_MouseLeftButtonDown({
        $script:xpClickCount++
        
        # Check if the magic number is reached (13 clicks)
        if ($script:xpClickCount -eq 13) {
            Start-Process $rickrollUrl
            
            # Reset the counter
            $script:xpClickCount = 0
            
            [System.Windows.MessageBox]::Show("Easter Egg Triggered! Rick-Rolled!", "Secret", 'OK', 'Information') | Out-Null
        }
    })

    $grid.Children.Add($imgXP) | Out-Null 
    # Ocupa las 4 columnas para que quede centrado
    [System.Windows.Controls.Grid]::SetRow($imgXP,0)
    [System.Windows.Controls.Grid]::SetColumnSpan($imgXP, 4)
}

# ---------------------------------------------------------
# DropShadow Effect for Text Contrast
# ---------------------------------------------------------
$textShadow = New-Object System.Windows.Media.Effects.DropShadowEffect
$textShadow.Color = [System.Windows.Media.Colors]::Black
$textShadow.Direction = 270
$textShadow.ShadowDepth = 2
$textShadow.Opacity = 0.8
$textShadow.BlurRadius = 3


# ---------------------------------------------------------
# Standard UI Elements 
# ---------------------------------------------------------

# Coins Timer Label
$labelCoins = New-Object System.Windows.Controls.TextBlock
$labelCoins.Text = "Countdown for Gold Coins:"
$labelCoins.FontFamily = $fontFamily
$labelCoins.FontWeight = "Bold"
$labelCoins.FontSize = 14
$labelCoins.Foreground = $foreground
$labelCoins.Effect = $textShadow
$labelCoins.HorizontalAlignment = "Center"
$labelCoins.Margin = "0,10,0,5"
$grid.Children.Add($labelCoins) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($labelCoins,1)
[System.Windows.Controls.Grid]::SetColumnSpan($labelCoins, 4)

# Coins Timer Input
$inputCoins = New-Object System.Windows.Controls.TextBox
$inputCoins.Text = "10" 
$inputCoins.FontFamily = $fontFamily
$inputCoins.FontWeight = "Bold"
$inputCoins.FontSize = 16
$inputCoins.Width = 80
$inputCoins.Margin = "0,0,0,10"
$inputCoins.HorizontalAlignment = "Center" 
$grid.Children.Add($inputCoins) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($inputCoins,2)
[System.Windows.Controls.Grid]::SetColumn($inputCoins, 1)

# Unidad para Coins (Mins)
$unitCoins = New-Object System.Windows.Controls.TextBlock
$unitCoins.Text = "Mins"
$unitCoins.FontFamily = $fontFamily
$unitCoins.FontWeight = "Bold"
$unitCoins.FontSize = 16
$unitCoins.Foreground = $foreground
$unitCoins.HorizontalAlignment = "Left" 
$unitCoins.VerticalAlignment = "Center"
$unitCoins.Margin = "5,0,0,10"
$grid.Children.Add($unitCoins) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($unitCoins,2)
[System.Windows.Controls.Grid]::SetColumn($unitCoins, 2)

# Start Coins Timer Button
$buttonCoins = New-Object System.Windows.Controls.Button
$buttonCoins.Content = "Start Coins Timer"
$buttonCoins.FontFamily = $fontFamily
$buttonCoins.FontWeight = "Bold"
$buttonCoins.FontSize = 16
$buttonCoins.Width = 150
$buttonCoins.Height = 40
$buttonCoins.Background = [System.Windows.Media.Brushes]::Black
$buttonCoins.Foreground = [System.Windows.Media.Brushes]::Yellow
$buttonCoins.Margin = "0,10,0,10"
$buttonCoins.Tag = $false
$buttonCoins.HorizontalAlignment = "Center"
$grid.Children.Add($buttonCoins) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($buttonCoins,3)
[System.Windows.Controls.Grid]::SetColumnSpan($buttonCoins, 4)


# AFK Countdown Label
$labelAFK = New-Object System.Windows.Controls.TextBlock
$labelAFK.Text = "AFK Countdown:"
$labelAFK.FontFamily = $fontFamily
$labelAFK.FontWeight = "Bold"
$labelAFK.FontSize = 14
$labelAFK.Foreground = $foreground
$labelAFK.Effect = $textShadow
$labelAFK.HorizontalAlignment = "Center"
$labelAFK.Margin = "0,10,0,5"
$grid.Children.Add($labelAFK) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($labelAFK,4)
[System.Windows.Controls.Grid]::SetColumnSpan($labelAFK, 4)

# AFK Timer Input
$inputAFK = New-Object System.Windows.Controls.TextBox
$inputAFK.Text = "14" 
$inputAFK.FontFamily = $fontFamily
$inputAFK.FontWeight = "Bold"
$inputAFK.FontSize = 16
$inputAFK.Width = 80
$inputAFK.Margin = "0,0,0,10"
$inputAFK.HorizontalAlignment = "Center"
$grid.Children.Add($inputAFK) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($inputAFK,5)
[System.Windows.Controls.Grid]::SetColumn($inputAFK, 1)

# Unidad para AFK (Mins)
$unitAFK = New-Object System.Windows.Controls.TextBlock
$unitAFK.Text = "Mins"
$unitAFK.FontFamily = $fontFamily
$unitAFK.FontWeight = "Bold"
$unitAFK.FontSize = 16
$unitAFK.Foreground = $foreground
$unitAFK.HorizontalAlignment = "Left" 
$unitAFK.VerticalAlignment = "Center"
$unitAFK.Margin = "5,0,0,10"
$grid.Children.Add($unitAFK) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($unitAFK,5)
[System.Windows.Controls.Grid]::SetColumn($unitAFK, 2)

# Start AFK Timer Button
$buttonAFK = New-Object System.Windows.Controls.Button
$buttonAFK.Content = "Start AFK Timer"
$buttonAFK.FontFamily = $fontFamily
$buttonAFK.FontWeight = "Bold"
$buttonAFK.FontSize = 16
$buttonAFK.Width = 150
$buttonAFK.Height = 40
$buttonAFK.Background = [System.Windows.Media.Brushes]::Black
$buttonAFK.Foreground = [System.Windows.Media.Brushes]::Yellow
$buttonAFK.Margin = "0,10,0,10"
$buttonAFK.Tag = $false
$buttonAFK.HorizontalAlignment = "Center"
$grid.Children.Add($buttonAFK) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($buttonAFK,6)
[System.Windows.Controls.Grid]::SetColumnSpan($buttonAFK, 4)

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "By Br4hx - https://github.com/BraVRom"
$footer.FontFamily = $fontFamily
$footer.FontSize = 12
$footer.Foreground = [System.Windows.Media.Brushes]::White
$footer.HorizontalAlignment = "Center"
$footer.VerticalAlignment = "Bottom"
$footer.Cursor = [System.Windows.Input.Cursors]::Hand
$footer.Margin = "0,0,0,0"
$footer.Add_MouseLeftButtonUp({ Start-Process "https://github.com/BraVRom" })
$mainGrid.Children.Add($footer) | Out-Null 
[System.Windows.Controls.Grid]::SetRow($footer, 9)
[System.Windows.Controls.Grid]::SetColumnSpan($footer, 4)


# ---------------------------------------------------------
# CORE FUNCTION: SHOW POPUP
# ---------------------------------------------------------
function Show-Popup($title, $message) {
    try {
        # Play sound if file exists
        $wavPath = Join-Path $assetsPath "reminder.wav"
        if (Test-Path $wavPath) {
            try {
                $player = New-Object System.Media.SoundPlayer $wavPath
                $player.Play()
            } catch {
                Write-Warning "Error playing sound: $_"
            }
        }

        # Create popup form
        $form = New-Object System.Windows.Forms.Form
        $form.Text = $title
        $form.Width = 300
        $form.Height = 150
        $form.FormBorderStyle = 'FixedDialog'
        $form.TopMost = $true
        $form.BackColor = [System.Drawing.Color]::Black
        $form.Opacity = 0.9
        $form.StartPosition = 'Manual'
        $form.ShowInTaskbar = $false 

        # Position top right corner
        $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
        $form.Left = $screenWidth - $form.Width - 10
        $form.Top = 10

        $label = New-Object System.Windows.Forms.Label
        $label.Text = $message
        $label.ForeColor = [System.Drawing.Color]::Yellow
        $label.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
        $label.TextAlign = 'MiddleCenter'
        $label.Dock = 'Fill'
        $form.Controls.Add($label) | Out-Null 

        # Timer for auto-close (8 seconds)
        $timer = New-Object System.Windows.Forms.Timer
        $timer.Interval = 8000 

        # CORE FIX: Link form to timer to prevent Null Reference error during close
        $timer.Tag = $form

        $timer.Add_Tick({
            $this.Stop()
            
            # Retrieve the form from the timer's Tag
            $myForm = $this.Tag

            if ($myForm) {
                $myForm.Close()
                $myForm.Dispose()
            }
            
            $this.Dispose()
        })

        $timer.Start()
        $form.Show()

    } catch {
        Write-Warning "Error displaying popup: $_"
    }
}

# ---------------------------------------------------------
# CORE LOGIC: TIMERS AND BUTTONS
# ---------------------------------------------------------

# System timers (WPF DispatcherTimers)
$coinsTimer = New-Object System.Windows.Threading.DispatcherTimer
$coinsTimer.Add_Tick({ Show-Popup "Gold Coins Reminder" "Time to collect your Gold Coins!" })

$afkTimer = New-Object System.Windows.Threading.DispatcherTimer
$afkTimer.Add_Tick({ Show-Popup "AFK Reminder" "Move your character!" })

# Helper function to set time interval with validation
function Set-TimerInterval($timerObj, $textbox) {
    $minutes = $null 
    # Establecer el límite máximo de 2 horas (120 minutos)
    $maxMinutes = 120
    
    # 1. Intentamos convertir el texto a un número
    if ([double]::TryParse($textbox.Text, [ref]$minutes)) {
        # 2. Validación de número positivo (> 0)
        if ($minutes -le 0) {
            [System.Windows.MessageBox]::Show("Please enter a positive number (minutes) greater than zero.","Input Error",'OK','Error') | Out-Null
            return $false
        }
        
        # 3. VALIDACIÓN DE LÍMITE MÁXIMO (2 HORAS)
        if ($minutes -gt $maxMinutes) {
            [System.Windows.MessageBox]::Show("The maximum allowed time is $maxMinutes minutes (2 hours). Please enter a smaller value.","Input Error",'OK','Error') | Out-Null
            return $false
        }

        $timerObj.Interval = [TimeSpan]::FromMinutes($minutes)
        return $true
    } else {
        # Si la conversión falla
        [System.Windows.MessageBox]::Show("Please enter a valid number in minutes.","Input Error",'OK','Error') | Out-Null
        return $false
    }
}

# Coins Button Event
$buttonCoins.Add_Click({
    if (-not $buttonCoins.Tag) {
        # Solo iniciar si la validación es exitosa
        if (Set-TimerInterval $coinsTimer $inputCoins) {
            $coinsTimer.Start()
            $buttonCoins.Content = "Stop Coins Timer"
            $buttonCoins.Tag = $true
            $buttonCoins.Background = [System.Windows.Media.Brushes]::DarkRed
            $buttonCoins.Foreground = [System.Windows.Media.Brushes]::White
        }
    } else {
        $coinsTimer.Stop()
        $buttonCoins.Content = "Start Coins Timer"
        $buttonCoins.Tag = $false
        $buttonCoins.Background = [System.Windows.Media.Brushes]::Black
        $buttonCoins.Foreground = [System.Windows.Media.Brushes]::Yellow
    }
})

# AFK Button Event
$buttonAFK.Add_Click({
    if (-not $buttonAFK.Tag) {
        # Solo iniciar si la validación es exitosa
        if (Set-TimerInterval $afkTimer $inputAFK) {
            $afkTimer.Start()
            $buttonAFK.Content = "Stop AFK Timer"
            $buttonAFK.Tag = $true
            $buttonAFK.Background = [System.Windows.Media.Brushes]::DarkRed
            $buttonAFK.Foreground = [System.Windows.Media.Brushes]::White
        }
    } else {
        $afkTimer.Stop()
        $buttonAFK.Content = "Start AFK Timer"
        $buttonAFK.Tag = $false
        $buttonAFK.Background = [System.Windows.Media.Brushes]::Black
        $buttonAFK.Foreground = [System.Windows.Media.Brushes]::Yellow
    }
})

# Stop timers when main window closes
$window.Add_Closed({
    $coinsTimer.Stop()
    $afkTimer.Stop()
})

# Show main window
$window.ShowDialog() | Out-Null
