$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8000/')
$listener.Start()
Write-Host '===================================================' -ForegroundColor Green
Write-Host '   Sparsh Setu NGO Web Server Active on Port 8000  ' -ForegroundColor Yellow
Write-Host '   Open http://localhost:8000/ in Google Chrome    ' -ForegroundColor Cyan
Write-Host '===================================================' -ForegroundColor Green

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $path = $request.Url.LocalPath
        if ($path -eq '/') { $path = '/index.html' }
        
        $filePath = Join-Path 'C:\Users\Archit\.gemini\antigravity\scratch\sparsh-setu' $path.TrimStart('/')
        
        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            $ext = [System.IO.Path]::GetExtension($filePath)
            
            switch ($ext) {
                '.html' { $response.ContentType = 'text/html; charset=utf-8' }
                '.js'   { $response.ContentType = 'application/javascript' }
                '.css'  { $response.ContentType = 'text/css' }
                '.jpg'  { $response.ContentType = 'image/jpeg' }
                '.png'  { $response.ContentType = 'image/png' }
                default { $response.ContentType = 'application/octet-stream' }
            }
            
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $buffer = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found')
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        $response.Close()
    } catch {
        # ignore errors on socket close
    }
}
