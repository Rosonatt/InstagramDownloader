import java.io.*;
import java.util.regex.*;
import java.util.Scanner;

public class InstagramDownloader {
    private String outputDir;
    
    public InstagramDownloader(String outputDir) {
        this.outputDir = outputDir;
        new File(outputDir).mkdirs();
    }
    
    private boolean validateUrl(String url, String contentType) {
        String pattern = "";
        switch(contentType) {
            case "reel":
                pattern = "^(https?://)?(www\\.)?instagram\\.com/reel/.*";
                break;
            case "video":
                pattern = "^(https?://)?(www\\.)?instagram\\.com/p/.*/.*";
                break;
            case "photo":
                pattern = "^(https?://)?(www\\.)?instagram\\.com/p/[^/]+/?$";
                break;
        }
        return Pattern.compile(pattern).matcher(url).matches();
    }
    
    public String download(String url, String contentType) {
        if (!validateUrl(url, contentType)) {
            return "URL inválida para " + contentType;
        }
        
        try {
            String command = "yt-dlp -o \"" + outputDir + "/%(title)s.%(ext)s\" " + url;
            Process process = Runtime.getRuntime().exec(command);
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            return "Download completo";
        } catch (Exception e) {
            return "Erro no download: " + e.getMessage();
        }
    }
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        InstagramDownloader downloader = new InstagramDownloader("downloads");
        
        System.out.println("Instagram Downloader");
        
        while (true) {
            System.out.print("\nTipo (reel/video/photo): ");
            String contentType = scanner.nextLine().toLowerCase();
            
            if (!contentType.equals("reel") && !contentType.equals("video") 
                && !contentType.equals("photo")) {
                System.out.println("Tipo inválido!");
                continue;
            }
            
            System.out.print("URL: ");
            String url = scanner.nextLine().trim();
            
            if (url.equalsIgnoreCase("sair") || url.equalsIgnoreCase("exit")) {
                break;
            }
            
            System.out.println(downloader.download(url, contentType));
        }
        scanner.close();
    }
}