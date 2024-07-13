# 基础镜像使用ubuntu:24.04
FROM liyaosong/ubuntu:24.04

# 设置非交互式前端（避免构建过程中的交互式提示）
ENV DEBIAN_FRONTEND=noninteractive

# 设置工作目录
WORKDIR /home/steam

# 插入 Steam 提示答案
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN groupadd -r steam && useradd -r -g steam steam \
    && chown -R steam:steam /home/steam \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates steamcmd \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd \
    && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /root/.cache \
    /var/cache/apt/archives/*.deb \
    /var/cache/apt/*.bin \
    /var/lib/apt/lists/* \
    /usr/share/*/*/*/*.gz \
    /usr/share/*/*/*.gz \
    /usr/share/*/*.gz \
    /usr/share/doc/*/README* \
    /usr/share/doc/*/*.txt \
    /usr/share/locale/*/LC_MESSAGES/*.mo 

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# 切换到非root用户
USER steam
# 更新SteamCMD
RUN steamcmd +quit
# 设置默认命令
ENTRYPOINT ["steamcmd"]
CMD ["+help", "+quit"]
