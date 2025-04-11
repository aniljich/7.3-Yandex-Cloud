# Домашнее задание к занятию "`7.3 Подъем инфраструктуры в облаке`" - `Коротков Андрей`
   # Домашнее задание к занятию «Подъём инфраструктуры в Yandex Cloud»



### Задание 1 

Повторить демонстрацию лекции(развернуть vpc, 2 веб сервера, бастион сервер)

### Задание 2 

С помощью ansible подключиться к web-a и web-b , установить на них nginx.(написать нужный ansible playbook)


Провести тестирование и приложить скриншоты развернутых в облаке ВМ, успешно отработавшего ansible playbook. 

### Ответ 2

Для файлов Ansible я использовал организацию на основе ролей. В решении существуют две роли: webserver (куда устанавливается Nginx) и database (туда устанавливается PostgreSQL в задании 3)

Скриншот виртуальных машин в облаке:
![Скриншот-1](https://github.com/aniljich/7.3-Yandex-Cloud/main/img/imgage1.png)

Скриншот отработавшего ansible playbook:
![Скриншот-2](https://github.com/aniljich/7.3-Yandex-Cloud/main/img/image2.png)

Блок кода с установкой Nginx:
```yaml
---
- name: Update apt cache
  ansible.builtin.apt:
    update_cache: true

- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present

- name: Deploy Nginx template
  ansible.builtin.template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: root
    group: root
    mode: o=rw,g=r,o=r
  notify: Restart Nginx

- name: Nginx autostart
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true

- name: Check availability
  ansible.builtin.uri:
    url: "http://{{ ansible_default_ipv4.address }}"
    follow_redirects: none
    method: GET
  register: http_result

- name: Print http_result status code
  ansible.builtin.debug:
    msg: "Return code is {{ http_result.status }}"
```

---

## Дополнительные задания* (со звёздочкой)

Их выполнение необязательное и не влияет на получение зачёта по домашнему заданию. Можете их решить, если хотите глубже и/или шире разобраться в материале.

--- 
### Задание 3*

**Выполните действия, приложите скриншот скриптов, скриншот выполненного проекта.**

1. Добавить еще одну виртуальную машину. 
2. Установить на нее любую базу данных. 
3. Выполнить проверку состояния запущенных служб через Ansible.

### Ответ 3*

Блок кода Ansible, устанавливающий PostgreSQL:
```yaml
---
- name: Update apt cache
  ansible.builtin.apt:
    update_cache: true

- name: Install PostgreSQL
  ansible.builtin.apt:
    name: postgresql
    state: present

- name: Ensure PostgreSQL service is running
  ansible.builtin.service:
    name: postgresql
    state: started

- name: Enable PostgreSQL service at boot
  ansible.builtin.service:
    name: postgresql
    enabled: true
```
Скриншот отработавщего Ansible:
![Скриншот-3](https://github.com/aniljich/7.3-Yandex-Cloud/main/img/image3.png)

--- 
### Задание 4*
Изучите [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart) yandex для terraform.
Добейтесь работы паплайна с безопасной передачей токена от облака в terraform через переменные окружения. Для этого:

1. Настройте профиль для yc tools по инструкции.
2. Удалите из кода строчку "token = var.yandex_cloud_token". Terraform будет считывать значение ENV переменной YC_TOKEN.
3. Выполните команду export YC_TOKEN=$(yc iam create-token) и в том же shell запустите terraform.
4. Для того чтобы вам не нужно было каждый раз выполнять export - добавьте данную команду в самый конец файла ~/.bashrc

### Ответ 4*

Скриншот отработавшего terraform apply после повторного запуска:
![Скриншот-4](https://github.com/aniljich/7.3-Yandex-Cloud/main/img/image4.png)

Результат выполнения команды echo $YC_TOKEN:
![Скриншот-5](https://github.com/aniljich/7.3-Yandex-Cloud/main/img/image5.png)

---