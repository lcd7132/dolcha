$prompt = "미래지향적인 웹사이트 단일 페이지의 전체 코드를 만들어주세요. HTML 내부에 CSS와 JS를 모두 포함한 형태(index.html)로 작성해주세요. 사이버펑크, 네온, 다크 모드, 글래스모피즘 같은 미래지향적 디자인 요소를 반영해주세요. 코드는 반드시 ```html 로 시작하고 ``` 로 끝나는 마크다운 코드 블록 안에 작성해주세요."
$body = @{ 
    model = "gemma4:e4b"
    messages = @(
        @{role="user"; content=$prompt}
    )
    temperature = 0.7
} | ConvertTo-Json -Depth 5 -Compress

$jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($body)

try {
    $response = Invoke-RestMethod -Uri "http://localhost:11434/v1/chat/completions" `
        -Method Post `
        -Body $jsonBytes `
        -ContentType "application/json; charset=utf-8"

    $content = $response.choices[0].message.content
    [IO.File]::WriteAllText("$(Get-Location)\local_response.md", $content, [System.Text.Encoding]::UTF8)
    Write-Host "Success"
} catch {
    Write-Host "Error: $_"
}
