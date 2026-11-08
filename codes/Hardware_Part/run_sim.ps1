
$ErrorActionPreference = "Stop"

# Locate project directories
$hardware = $PSScriptRoot
$root = Split-Path (Split-Path $hardware -Parent) -Parent
$build = Join-Path $root "build"

New-Item -ItemType Directory -Force -Path $build | Out-Null

$exe = Join-Path $build "tb.v.out"
$vcd = Join-Path $hardware "cpu.vcd"

# Remove old outputs
Remove-Item $exe -ErrorAction SilentlyContinue
Remove-Item $vcd -ErrorAction SilentlyContinue

Write-Host "Compiling testbench..."

# Compile from the hardware directory
Push-Location $hardware
try {
    iverilog -g2012 -o $exe tb.v

    if ($LASTEXITCODE -ne 0) {
        throw "Compilation failed. Check the compiler errors above."
    }

    Write-Host "Running simulation..."
    vvp $exe

    if ($LASTEXITCODE -ne 0) {
        throw "Simulation failed."
    }
}
finally {
    Pop-Location
}

if (-not (Test-Path $vcd)) {
    throw "cpu.vcd was not generated."
}

Write-Host "Opening GTKWave..."
gtkwave $vcd
