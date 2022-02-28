# Kekkon

Kekkon 是一个相亲软件。

# 运行
## 开发模式
在保证本地具有 go-flutter 开发环境后（包括 Xcode、Dart、Flutter、Go 以及 hover），使用以下命令启动应用

```
cd kekkon/ && hover run
```

## 打包
由于打包需要的环境比较复杂，因此最好使用 Docker 进行打包，因此需要保证你的本地运行有 Docker，并保证网络良好。

### Windows

```
hover build windows --docker
```

运行后在 `kekkon/go/build/outputs/windows` 下即可以运行 `.exe` 可执行文件。若要移植到其他 Windows 操作系统，需要将整个文件夹一起拷贝，因为其中包括了运行依赖的 `flutter_engine.dll` 文件。

#### Windows Building Bug Fix log

在使用最新版本的 ```hover``` 进行构建时，遇到了一系列的问题，本小节为构建过程 ```BUG FIX``` 的记录；

-------

**Case 1: 构建时 hover 拉取对应版本镜像 Not Found**

```Unable to find image 'goflutter/hover:v0.46.6' locally docker container: docker: Error response from daemon: manifest for goflutter/hover:v0.46.6 not found: manifest unknown: manifest unknown.```

该报错是因为 hover 的某个版本的镜像找不到，原因是 hover 在发布新版本之后经常忘记发布镜像... 因此解决的办法有两种：

1. 自己构建

```
git clone https://github.com/go-flutter-desktop/hover
cd hover
./install-with-docker-image.sh
```
related issue：https://github.com/go-flutter-desktop/go-flutter/issues/616

2. 拉取 hover 的 latest 而非具体版本号

因为如果 go get 最新 hover 时，hover 会拉取该最新版本号而非 latest 的镜像；但是如果 git clone 了 ```github.com/go-flutter-desktop/hover``` 后执行 ```go build```，然后用该构建产物代替使用安装好的 hover，即可拉取镜像源能查找到的最新的版本；

**Case 2: Flutter 编译报错**

```flutter/lib/src/semantics/semantics Error: Required named parameter 'decreasedValueAttributes' must be provided.```

该报错的原因是 flutter 的一个临时 BUG，如果使用 ```flutter channel master``` 最新的代码则没有该问题，问题在于 hover 要求使用 ```flutter channel beta``` 的代码，而且在本地多次切换版本后依然无果；

解决切换版本无效的办法是自己进入容器进行编译，而不是使用 hover 写好的命令；

原先的命令为：

```
docker run --rm \
--mount type=bind,source=/{SOURCE-CODE_PATH}/kekkon,target=/app \
--mount type=bind,source=/Users/{USERNAME}/Library/Caches/hover/engine,target=/root/.cache/hover/engine \
--mount type=bind,source=/Users/{USERNAME}/Library/Caches/hover/docker-go-cache,target=/go-cache \
--env GOCACHE=/go-cache \
--env HOVER_SAFE_CHOWN_UID=501 \
--env HOVER_SAFE_CHOWN_GID=20 \
--env GOPROXY='https://goproxy.cn,direct' \
--env GOPRIVATE='git.smartisan.com' \
goflutter/hover:v0.43.0 hover-safe.sh build windows --skip-engine-download --version-number 0.0.1
```

命令中使用了 ```hover-safe.sh``` 来进行编译，但是实际上可以看出该命令是挂载了 hover 命令到容器中的。所以在我将命令替换为 ```docker run -it .... /bin/bash``` 后进入容器执行 ```hover build windows``` 后便编译成功了。并且生成的文件也会同步到磁盘上。
（当然，你也可以直接执行 ```docker run --rm .... hover build windows```）

------

### Linux

```
hover build linux-deb --docker
```

运行后在 `kekkon/go/build/outputs/linux-deb` 下即可以找到 `.deb` 文件以用于安装应用。

### MacOS

```
hover build darwin-dmg --docker
```

运行后在 `kekkon/go/build/outputs/darwin-dmg` 下即可以找到 `.dmg` 文件以用于安装应用。

## 声明
不得将此应用用于任何商业用途。