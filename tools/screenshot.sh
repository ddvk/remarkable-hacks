ssh rm "cat /dev/fb0" |
  ffmpeg -vcodec rawvideo -f rawvideo -pix_fmt gray16le -s 1408,1872 -i - -vframes 1 -vf scale=300x400 -f image2 -vcodec png $1
