ARG DOTNET_VERSION

FROM ubuntu AS pre

ARG DOTNET_VERSION
ENV DOTNET_VERSION ${DOTNET_VERSION}

RUN apt update -y \
    && apt install dotnet-sdk-${DOTNET_VERSION} wget unzip -y

ARG GODOT_VERSION
ENV GODOT_VERSION ${GODOT_VERSION}

RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64.zip \
    && wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz

RUN unzip Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64/GodotSharp  /usr/local/bin/GodotSharp \
    && mv Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64/Godot_v${GODOT_VERSION}-stable_mono_linux.x86_64 /usr/local/bin/godot \
    && rm -rf Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64 Godot_v${GODOT_VERSION}-stable_mono_linux_x86_64.zip \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono

RUN unzip Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz \
    && mv templates/linux_release.x86_64 /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/linux_release.x86_64

#RUN mv templates/linux_debug.x86_64 /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/linux_debug.x86_64

#rm -rf Godot_v${GODOT_VERSION}-stable_mono_export_templates.tpz

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION} as final

ENV DOTNET_VERSION ${DOTNET_VERSION}

ARG GODOT_VERSION
ENV GODOT_VERSION ${GODOT_VERSION}

COPY --from=pre /usr/local/bin/godot /usr/local/bin/godot
COPY --from=pre /usr/local/bin/GodotSharp /usr/local/bin/GodotSharp

RUN mkdir -p /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono

COPY --from=pre /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/linux_release.x86_64 /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/linux_release.x86_64
#COPY --from=pre /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/linux_debug.x86_64 /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono/linux_debug.x86_64

CMD /bin/bash