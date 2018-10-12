
$("#micropost_picture").bind("change", function() {
  var size_in_megabytes = this.files[0].size/Settings.size_image/Settings.size_image;
  if (size_in_megabytes > Settings.size_image_mb) {
    alert(t "max_size_file");
  }
});
