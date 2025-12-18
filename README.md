# Dynamic Linking on Linux

> Chapitre pratique inspiré de **Mastering Android NDK** — compréhension approfondie du *dynamic linking* sous Linux, avant d’aborder Android.

---

## 🎯 Objectifs du chapitre

À la fin de ce chapitre, tu dois être capable de :

* Comprendre ce qu’est le **dynamic linking** sous Linux
* Différencier **static linking** et **dynamic linking**
* Savoir comment le **loader dynamique (`ld-linux`)** fonctionne
* Créer et utiliser une **bibliothèque partagée (`.so`)**
* Diagnostiquer les erreurs de linkage et de chargement
* Faire le lien conceptuel avec **Android NDK**

---

## 🧠 Rappels conceptuels

### 🔹 Qu’est-ce que le dynamic linking ?

Le *dynamic linking* consiste à **lier une bibliothèque partagée au moment de l’exécution**, et non à la compilation finale.

* La bibliothèque n’est **pas copiée** dans l’exécutable
* Elle est chargée par le **dynamic loader**
* Plusieurs programmes peuvent partager la même `.so`

---

### 🔹 Comparaison : statique vs dynamique

| Critère         | Static linking       | Dynamic linking   |
| --------------- | -------------------- | ----------------- |
| Extension       | `.a`                 | `.so`             |
| Taille binaire  | Élevée               | Faible            |
| Partage mémoire | ❌ Non                | ✅ Oui             |
| Mise à jour lib | ❌ Recompiler         | ✅ Remplacer `.so` |
| Performance     | Légèrement meilleure | Très proche       |

---

## 🧱 Architecture du dynamic linking

```text
Programme ELF
   |
   |-- NEEDED: libfoo.so
   |
Dynamic Loader (ld-linux)
   |
   |-- Recherche des bibliothèques
   |-- Résolution des symboles
   |-- Relocations
   |-- Lancement de main()
```

---

## 🔍 Le dynamic loader

Sous Linux :

* `ld-linux-x86-64.so.2` (x86_64)
* `ld-linux-armhf.so.3` (ARM)

Commandes utiles :

```bash
ldd myprogram
readelf -d myprogram
```

---

## 🛠️ Pratique — créer une bibliothèque partagée

### 1️⃣ Code source

**mymath.c**

```c
int add(int a, int b) {
    return a + b;
}
```

### 2️⃣ Compilation de la bibliothèque

```bash
gcc -fPIC -shared mymath.c -o libmymath.so
```

📌 `-fPIC` = *Position Independent Code*

---

### 3️⃣ Programme utilisant la librairie

**main.c**

```c
#include <stdio.h>

int add(int, int);

int main() {
    printf("Result: %d\n", add(2, 3));
    return 0;
}
```

---

### 4️⃣ Compilation et linkage

```bash
gcc main.c -L. -lmymath -o app
```

---

### 5️⃣ Exécution

```bash
./app
```

❌ Erreur probable :

```text
error while loading shared libraries: libmymath.so
```

---

## 🧩 Résolution des chemins de bibliothèques

### 🔹 Méthode 1 — LD_LIBRARY_PATH

```bash
export LD_LIBRARY_PATH=.
./app
```

### 🔹 Méthode 2 — RPATH (recommandée)

```bash
gcc main.c -L. -lmymath -Wl,-rpath,'$ORIGIN' -o app
```

---

## 🔎 Outils de diagnostic

| Outil        | Usage                |
| ------------ | -------------------- |
| `ldd`        | Voir les dépendances |
| `nm -D`      | Symboles dynamiques  |
| `readelf -d` | Section dynamique    |
| `objdump -p` | Infos ELF            |

---

## ⚠️ Erreurs classiques

* ❌ Oublier `-fPIC`
* ❌ Mauvais ordre des options (`-l` après les sources)
* ❌ Bibliothèque non trouvée à l’exécution
* ❌ Conflit de versions de `.so`

---

## 🔗 Lien avec Android NDK

| Linux             | Android                                 |
| ----------------- | --------------------------------------- |
| `.so` système     | `.so` dans APK                          |
| `ld-linux`        | linker Android (`/system/bin/linker64`) |
| `LD_LIBRARY_PATH` | `System.loadLibrary()`                  |

�� Android **n’autorise pas** les `.so` système arbitraires.

---

## 🎯 Ce qu’il faut absolument retenir

* Le dynamic linking est **fondamental** pour Android
* Linux est un **terrain d’apprentissage indispensable**
* Comprendre ELF = comprendre Android NDK

---

## 🚀 Prochaine étape

➡️ **Dynamic linking sur Android**

* JNI
* `System.loadLibrary()`
* ABI et packaging APK

---

> ✍️ Auteur : Notes personnelles d’étude — Mastering Android NDK
>
> 📚 Objectif : comprendre avant d’implémenter

