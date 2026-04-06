# 📱 Pomor – App de Produtividade (Pomodoro)

## 🎯 Objetivo

O Pomor é um aplicativo de produtividade baseado na técnica Pomodoro, permitindo ao usuário criar, gerenciar e executar tarefas com controle de tempo.

---

## 🏗️ Arquitetura

O projeto foi desenvolvido utilizando **MVVM (Model-View-ViewModel)** em conjunto com princípios de **Clean Architecture**, garantindo separação de responsabilidades, testabilidade e escalabilidade.

### 📌 Organização:

* **View (SwiftUI)**

  * Responsável pela interface e interação com o usuário

* **ViewModel**

  * Gerencia o estado da UI e a comunicação com os UseCases

* **Domain (UseCases)**

  * Contém as regras de negócio da aplicação
  * Ex: criação, atualização e exclusão de tarefas

* **Data**

  * Implementação do repositório e persistência local (`UserDefaults`)

Essa abordagem reduz o acoplamento entre camadas e facilita a manutenção do código.

---

## 🧩 Design Patterns

Durante o desenvolvimento, foram aplicados alguns padrões de projeto para melhorar a organização e qualidade do código:

* **MVVM (Model-View-ViewModel)**
  Utilizado para separar a lógica de interface da lógica de negócio, mantendo as Views simples e reativas.

* **Repository Pattern**
  Abstrai o acesso aos dados, permitindo trocar facilmente a fonte de dados (ex: local ou remota) sem impactar o restante da aplicação.

* **Use Case Pattern**
  Encapsula regras de negócio específicas (ex: adicionar ou atualizar tarefas), evitando lógica diretamente nas Views ou ViewModels.

* **Dependency Injection**
  As dependências (como repositórios) são injetadas nos UseCases e ViewModels, facilitando testes e desacoplamento.

* **Observer Pattern (via Combine / @Published)**
  Utilizado nos ViewModels para atualizar automaticamente a UI quando o estado muda.

---

## 🔄 Navegação

A navegação foi implementada com `NavigationStack` e um **Router customizado (`AppRouter`)**, utilizando um enum de rotas (`AppRoute`).

Isso permite centralizar e desacoplar a lógica de navegação das views.

---

## 📋 Funcionalidades Principais

### ✅ Gerenciamento de Tarefas

* Criar tarefas com título, duração e ícone
* Editar tarefas existentes
* Excluir tarefas com confirmação

---

### ⏱️ Timer (Pomodoro)

* Contagem regressiva baseada na tarefa
* Controles de iniciar, pausar e resetar
* Atualização de progresso em tempo real

---

### 💾 Persistência

* Armazenamento local utilizando `UserDefaults`
* Serialização com `Codable`

---

### ⚠️ Tratamento de Erros

* Tratamento nas camadas de domínio e dados
* Exibição de mensagens amigáveis na interface

---

## 🧪 Testes Unitários

Foram implementados testes com `XCTest`, cobrindo os principais fluxos:

* **TaskListViewModel**

  * Carregamento e exclusão de tarefas
  * Tratamento de erros

* **TaskFormViewModel**

  * Validação de formulário
  * Criação e edição
  * Tratamento de erros

* **TimerViewModel**

  * Controle do timer
  * Cálculo de progresso

Os testes utilizam **injeção de dependência e mocks**, garantindo isolamento e previsibilidade.

---

## 🎥 Vídeo de Demonstração

---

## 🚀 Como Executar

1. Abrir o projeto no Xcode
2. Selecionar um simulador
3. Executar o app

---

## 📌 Conclusão

O aplicativo atende aos requisitos propostos utilizando:

* Arquitetura **MVVM + Clean Architecture**
* Aplicação de **Design Patterns**
* Navegação desacoplada
* Persistência local funcional
* Testes unitários cobrindo os principais cenários

---
