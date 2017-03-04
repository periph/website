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
    <meta http-equiv="refresh" content="0; URL='https://godoc.org/periph.io{{$path}}'" />
  {{- else -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/periph/{{$repoName}}" />
    <meta http-equiv="refresh" content="0; URL='https://godoc.org/periph.io{{$path}}'" />
  {{- end -}}
  <script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-93006956-1', 'auto');
		ga('send', 'pageview');
	</script>
</head>
<body>
  <h1>Periph</h1>
  Are you looking for a Go package?<p>
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
