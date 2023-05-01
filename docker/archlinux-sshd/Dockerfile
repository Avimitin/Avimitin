FROM archlinux:latest
RUN pacman -Syu --noconfirm --needed
RUN pacman -S --noconfirm --needed \
      openssh sudo curl

RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -m -s /bin/bash avimitin
RUN usermod -aG wheel avimitin
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
RUN echo "LANG=en_US.UTF-8" >> /etc/locale.conf

RUN /usr/bin/ssh-keygen -A
RUN mkdir -p /home/avimitin/.ssh
COPY keys/authorized_keys /home/avimitin/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/bin/sshd", "-D"]
