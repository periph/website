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
