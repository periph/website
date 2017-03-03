<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>{{.Doc.title}}</title>
  <meta name="description" content="{{.Doc.description}}">
  <meta name="author" content="{{.Doc.author}}">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="//fonts.googleapis.com/css?family=Raleway:400,300,600" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="/css/skeleton.min.css">
  <link rel="icon" type="image/png" href="favicon.ico">
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
  <div class="container">
    <div class="row">
      <div class="one-half column">
        {{- .Doc.body -}}
      </div>
    </div>
  </div>
</body>
</html>
