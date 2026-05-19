import sys, pathlib

# app.py reponun kokunde duruyor; tests dosyalari onu "import app" ile
# cagiriyor. Bu shim, koku sys.path'e ekleyerek pytest'in app.py'yi
# bulmasini saglar.
sys.path.insert(0, str(pathlib.Path(__file__).parent))
