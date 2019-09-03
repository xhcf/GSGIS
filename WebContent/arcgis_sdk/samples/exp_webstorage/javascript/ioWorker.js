// Base64 conversion functions
importScripts("_base.js");

// Parent to worker
onmessage = function(evt) {
  getImages(evt.data);
};

function getImages(urls) {
  for (var i = 0; i < urls.length; i++) {
    var imgBytes = getImage(urls[i]);
    if (imgBytes) {
      var encoded = Base64Utils.wordToBase64(Base64Utils.stringToWord(imgBytes));
      postMessage([ urls[i], encoded ]);
    }
  } // loop
}

function getImage(url) {
  url = "/arcgisserver/apis/javascript/proxy/proxy.ashx?" + url;

  var req = new XMLHttpRequest();
  req.open("GET", url, false);
  req.overrideMimeType("text/plain; charset=x-user-defined");
  req.send(null);

  if (req.status != 200) {
    return "";
  }
 
  return req.responseText;
}