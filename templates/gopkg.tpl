{{/* Implement redirection for periph.io/x/... URLs */}}
{{- $path := .URL.Query.Get "path" -}}
{{- if len $path | ne 0 -}}
  {{- $repoName := index (.Split $path "/") 2 -}}
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  {{- if eq $repoName "periph" -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/google/{{$repoName}
    <meta http-equiv="refresh" content="0; URL='https://godoc.org/periph.io{{$path}}'" />
  {{- else -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/periph/{{$repoName}
    <meta http-equiv="refresh" content="0; URL='https://godoc.org/periph.io{{$path}}'" />
  {{- end -}}
</head>
<body>
  Are you looking for a Go package?
  Maybe it exists on
  {{- if eq $repoName "periph" -}}
    <a href="https://github.com/google/{{$repoName}}">Github</a>,
  {{- else -}}
    <a href="https://github.com/periph/{{$repoName}}">Github</a>,
  {{- end -}}
  or on <a href="https://godoc.org/periph.io{{$path}}">GoDoc</a>.
</body>
</html>
{{- end -}}
