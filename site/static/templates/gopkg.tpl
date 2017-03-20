{{/* Implement redirection for periph.io/x/... URLs */}}
{{- $path := .URL.Query.Get "path" -}}
{{- if len $path | ne 0 -}}
  {{- $repoName := index (.Split $path "/") 2 -}}
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  {{- if eq $repoName "periph" -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/google/{{$repoName}}" />
  {{- else -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/periph/{{$repoName}}" />
  {{- end -}}
  <noscript>
    <meta name="destination" http-equiv="refresh" content="0; URL='https://godoc.org/periph.io{{$path}}'" />
  </noscript>
  <script src="/js/ga.js"></script>
</head>
<body>Redirecting to <a id=dest href="https://godoc.org/periph.io{{$path}}">https://godoc.org/periph.io{{$path}}</a>...</body>
<script src="/js/redirect.js"></script>
</html>
{{- end -}}
