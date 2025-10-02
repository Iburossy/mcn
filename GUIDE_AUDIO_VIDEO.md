# 🎬 Guide Audio & Vidéo - URLs Valides

## ⚠️ Problème Résolu

**Erreur :** "The element has no supported sources"

**Cause :** Utilisation de liens YouTube pour l'audio (non supporté)

**Solution :** Utiliser des fichiers audio directs (MP3) ou des iframes YouTube pour vidéo

## 🎧 Audio Guide - URLs Valides

### ✅ Formats Supportés

**Fichiers Audio Directs :**
- MP3 (recommandé)
- WAV
- OGG

### ❌ Ne Fonctionne PAS

- ❌ Liens YouTube (`https://youtube.com/watch?v=...`)
- ❌ Liens YouTube courts (`https://youtu.be/...`)
- ❌ Liens Spotify
- ❌ Liens SoundCloud (sauf embed)

### 🔗 Exemples d'URLs Valides

**1. Fichier MP3 hébergé :**
```
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
https://file-examples.com/storage/fe7e0e2b8e66e1b0a9c7e1e/2017/11/file_example_MP3_700KB.mp3
```

**2. Cloudinary :**
```
https://res.cloudinary.com/demo/video/upload/v1234567890/audio_fr.mp3
```

**3. Serveur local :**
```
http://localhost:5000/uploads/audio/oeuvre1_fr.mp3
```

### 📝 Comment Obtenir des URLs Audio

#### Option 1: Cloudinary (Recommandé)

1. Aller sur https://cloudinary.com
2. Upload → Audio
3. Copier "Secure URL"
4. Coller dans le formulaire

#### Option 2: Hébergement Gratuit

**Freesound.org** (Sons libres)
1. Chercher un son
2. Télécharger
3. Uploader sur Cloudinary
4. Utiliser l'URL

**Archive.org** (Domaine public)
1. Chercher audio
2. Clic droit sur lecteur → "Copier l'URL audio"
3. Utiliser l'URL

#### Option 3: Serveur Local

```bash
# Créer dossier uploads
mkdir back/uploads/audio

# Copier fichiers MP3
cp audio_fr.mp3 back/uploads/audio/

# URL: http://localhost:5000/uploads/audio/audio_fr.mp3
```

## 🎥 Vidéo Guide - URLs Valides

### ✅ Formats Supportés

**1. YouTube (Recommandé pour tests)**
- ✅ `https://youtube.com/watch?v=VIDEO_ID`
- ✅ `https://youtu.be/VIDEO_ID`
- ✅ `https://youtube.com/embed/VIDEO_ID`

**Le système convertit automatiquement en iframe !**

**2. Fichiers Vidéo Directs**
- MP4 (recommandé)
- WebM
- OGG

### 🔗 Exemples d'URLs Valides

**YouTube :**
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ
https://youtu.be/dQw4w9WgXcQ
```

**Fichier MP4 :**
```
https://www.w3schools.com/html/mov_bbb.mp4
https://res.cloudinary.com/demo/video/upload/v1234567890/video_fr.mp4
```

### 📝 Comment Obtenir des URLs Vidéo

#### Option 1: YouTube (Le Plus Simple)

1. Trouver une vidéo sur YouTube
2. Copier l'URL complète
3. Coller dans le formulaire
4. ✅ Ça marche automatiquement !

**Formats acceptés :**
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://www.youtube.com/embed/VIDEO_ID`

#### Option 2: Vimeo

```
https://player.vimeo.com/video/VIDEO_ID
```

#### Option 3: Cloudinary

1. Upload vidéo sur Cloudinary
2. Copier "Secure URL"
3. Utiliser l'URL

## 🧪 URLs de Test

### Audio (Fonctionnent Immédiatement)

```
# Musique classique (MP3)
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3

# Exemple court (MP3)
https://file-examples.com/storage/fe7e0e2b8e66e1b0a9c7e1e/2017/11/file_example_MP3_700KB.mp3

# Nature sounds
https://www.kozco.com/tech/piano2.mp3
```

### Vidéo (Fonctionnent Immédiatement)

```
# YouTube - Musée du Louvre
https://www.youtube.com/watch?v=6vuetQSwFW8

# YouTube - Art africain
https://www.youtube.com/watch?v=dQw4w9WgXcQ

# Fichier MP4 direct
https://www.w3schools.com/html/mov_bbb.mp4
```

## 📋 Checklist Avant Upload

### Pour l'Audio

- [ ] Le fichier est en MP3, WAV ou OGG
- [ ] L'URL se termine par `.mp3`, `.wav` ou `.ogg`
- [ ] L'URL est accessible (pas de login requis)
- [ ] Le fichier fait moins de 10MB

### Pour la Vidéo

- [ ] C'est un lien YouTube OU un fichier MP4
- [ ] L'URL est publique
- [ ] La vidéo dure moins de 10 minutes (recommandé)

## 🎯 Workflow Recommandé

### Pour le Hackathon (Tests Rapides)

**Audio :**
```
Utiliser les URLs de test ci-dessus
```

**Vidéo :**
```
Utiliser YouTube (conversion automatique)
```

### Pour la Production

**Audio :**
1. Enregistrer audio professionnel
2. Convertir en MP3 (128-192 kbps)
3. Uploader sur Cloudinary
4. Utiliser l'URL

**Vidéo :**
1. Créer vidéo explicative
2. Uploader sur YouTube (privé ou non listé)
3. Copier l'URL
4. Utiliser dans le formulaire

## 🐛 Dépannage

### "No supported sources" (Audio)

**Cause :** URL YouTube utilisée pour l'audio

**Solution :**
1. Télécharger l'audio de YouTube (youtube-dl, yt-dlp)
2. Convertir en MP3
3. Uploader sur Cloudinary
4. Utiliser la nouvelle URL

### Vidéo ne charge pas

**Vérifier :**
- [ ] L'URL YouTube est correcte
- [ ] La vidéo n'est pas privée
- [ ] Le format MP4 est H.264 (si fichier direct)

### Audio ne joue pas

**Vérifier :**
- [ ] L'URL se termine par `.mp3`
- [ ] Le fichier est accessible (tester dans navigateur)
- [ ] Pas de CORS bloqué (console navigateur)

## 💡 Astuces

### Convertir YouTube → MP3

**Outils en ligne :**
- ytmp3.cc
- y2mate.com
- onlinevideoconverter.com

**Ligne de commande :**
```bash
# Installer yt-dlp
pip install yt-dlp

# Télécharger audio
yt-dlp -x --audio-format mp3 "https://youtube.com/watch?v=VIDEO_ID"
```

### Hébergement Gratuit

**Audio & Vidéo :**
- Cloudinary (25 GB gratuit)
- Archive.org (Illimité, domaine public)
- Google Drive (15 GB gratuit, lien direct)

## ✅ Résumé

| Type | Format | Exemple URL |
|------|--------|-------------|
| Audio | MP3 | `https://.../audio.mp3` |
| Audio | WAV | `https://.../audio.wav` |
| Vidéo | YouTube | `https://youtube.com/watch?v=ID` |
| Vidéo | MP4 | `https://.../video.mp4` |

**L'essentiel :**
- ✅ Audio = Fichier MP3 direct
- ✅ Vidéo = YouTube (auto-converti) OU MP4 direct
- ❌ Pas de YouTube pour l'audio !
