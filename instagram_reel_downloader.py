import os
import re
import yt_dlp
from typing import Optional, Literal

class InstagramDownloader:
    CONTENT_TYPES = ['reel', 'video', 'photo']
    URL_PATTERNS = {
        'reel': r'(https?://)?(www\.)?instagram\.com/reel/',
        'video': r'(https?://)?(www\.)?instagram\.com/p/.*/.*',
        'photo': r'(https?://)?(www\.)?instagram\.com/p/[^/]+/?$'
    }

    def __init__(self, output_dir="downloads"):
        self.output_dir = output_dir
        self._setup()

    def _setup(self):
        try:
            os.makedirs(self.output_dir, exist_ok=True)
        except Exception as e:
            print(f"Erro ao criar diretório: {e}")

    def validate_url(self, url, content_type):
        return re.search(self.URL_PATTERNS[content_type], url) is not None

    def get_download_options(self, content_type):
        options = {
            'outtmpl': os.path.join(self.output_dir, '%(title)s.%(ext)s'),
            'quiet': True,
            'no_warnings': True
        }
        if content_type in ['reel', 'video']:
            options['format'] = 'best'
        elif content_type == 'photo':
            options['format'] = 'best[ext=jpg]'
        return options

    def download(self, url, content_type):
        if not self.validate_url(url, content_type):
            return f"URL inválida para {content_type}"
        
        try:
            with yt_dlp.YoutubeDL(self.get_download_options(content_type)) as ydl:
                info = ydl.extract_info(url, download=True)
                return f"Download completo: {ydl.prepare_filename(info)}"
        except Exception as e:
            return f"Erro no download: {e}"

print("Instagram Downloader")
downloader = InstagramDownloader()

while True:
    content_type = input("\nTipo (reel/video/photo): ").lower()
    if content_type not in downloader.CONTENT_TYPES:
        print("Tipo inválido!")
        continue
        
    url = input("URL: ").strip()
    if url.lower() in ('sair', 'exit'):
        break
        
    print(downloader.download(url, content_type))