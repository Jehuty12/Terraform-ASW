"# Terraform AWS Infrastructure Project

Ce projet contient une infrastructure complète AWS déployée avec Terraform, comprenant deux architectures principales : IaaS (Infrastructure as a Service) et PaaS (Platform as a Service).

## 🏗️ Architecture du Projet

```
├── IAAS/                    # Infrastructure as a Service
│   ├── terraform/           # Configuration Terraform pour IaaS
│   ├── ansible/             # Configuration Ansible
│   └── sample-app/          # Application Laravel de démonstration
├── PAAS/                    # Platform as a Service
│   ├── modules/             # Modules Terraform pour PaaS
│   └── terraform.tfstate.d/ # États Terraform par environnement
└── terraform.tfstate.d/    # États globaux
```

## 📋 Composants

### IaaS (Infrastructure as a Service)
L'architecture IaaS déploie une infrastructure traditionnelle avec :

**Modules disponibles :**
- **ALB** : Application Load Balancer
- **ASG** : Auto Scaling Group  
- **CloudFront** : CDN
- **CloudWatch** : Monitoring et logs
- **IAM** : Gestion des identités et accès
- **Route 53** : DNS

**Application incluse :**
- **Sample App** : Application Laravel avec base MySQL
  - Gestion de schéma de base de données
- Tests automatisés
- Support Docker et Kubernetes

### PaaS (Platform as a Service)
L'architecture PaaS utilise des services managés AWS :

**Modules disponibles :**
- **API Gateway** : Gestion des APIs REST
- **CloudFront** : Distribution de contenu
- **Cognito** : Authentification et autorisation
- **DynamoDB** : Base de données NoSQL
- **Lambda** : Fonctions serverless
- **Route 53** : Gestion DNS
- **S3** : Stockage objet

## 🚀 Guide de Démarrage Rapide

### Prérequis
- Terraform >= 1.0
- AWS CLI configuré (voir guide ci-dessous)
- Ansible (pour IaaS)
- PHP >= 8.0 et Composer (pour sample-app)
- Node.js >= 16 (pour les fonctions Lambda)

### 🔧 Configuration AWS CLI (Débutants)

Si vous débutez avec AWS, suivez ces étapes pour configurer votre environnement :

#### 1. Création d'un compte AWS
1. Rendez-vous sur [aws.amazon.com](https://aws.amazon.com)
2. Cliquez sur "Créer un compte AWS"
3. Suivez les instructions (carte bancaire requise, mais niveau gratuit disponible)
4. Activez l'authentification à deux facteurs (recommandé)

#### 2. Installation d'AWS CLI

**Windows :**
```powershell
# Option 1: Via l'installateur MSI
# Télécharger depuis: https://aws.amazon.com/cli/

# Option 2: Via chocolatey
choco install awscli

# Option 3: Via pip
pip install awscli
```

**macOS :**
```bash
# Via Homebrew
brew install awscli

# Via pip
pip install awscli
```

**Linux :**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install awscli

# CentOS/RHEL
sudo yum install awscli

# Via pip
pip install awscli
```

#### 3. Création des clés d'accès AWS

1. **Connectez-vous à la console AWS**
2. **Accédez à IAM** (Identity and Access Management)
3. **Créez un utilisateur pour Terraform :**
   - Nom : `terraform-user`
   - Type d'accès : "Accès par programmation"
   - Permissions : Attachez les politiques suivantes (ou créez un groupe) :
     - `AmazonEC2FullAccess`
     - `AmazonS3FullAccess`
     - `AmazonRoute53FullAccess`
     - `CloudFrontFullAccess`
     - `IAMFullAccess`
     - `AmazonDynamoDBFullAccess`
     - `AWSLambdaFullAccess`
     - `AmazonAPIGatewayAdministrator`
     - `AmazonCognitoPowerUser`
     - `CloudWatchFullAccess`

⚠️ **Sécurité :** En production, utilisez des permissions plus restrictives selon le principe du moindre privilège.

4. **Notez vos clés :**
   - `Access Key ID` 
   - `Secret Access Key`
   - ⚠️ Ne partagez jamais ces clés et ne les commitez pas dans Git !

#### 4. Configuration d'AWS CLI

```bash
# Configuration interactive
aws configure

# Saisir vos informations :
# AWS Access Key ID: [Votre Access Key ID]
# AWS Secret Access Key: [Votre Secret Access Key]  
# Default region name: eu-west-1  # ou votre région préférée
# Default output format: json
```

#### 5. Vérification de la configuration

```bash
# Tester la connexion
aws sts get-caller-identity

# Lister vos buckets S3 (si vous en avez)
aws s3 ls

# Vérifier la région configurée
aws configure get region
```

#### 6. Configuration des régions AWS

**Régions recommandées pour la France :**
- `eu-west-1` (Irlande) - Le plus proche
- `eu-west-3` (Paris) - Centre de données en France
- `eu-central-1` (Francfort) - Alternative

```bash
# Changer de région
aws configure set region eu-west-3
```

#### 7. Bonnes pratiques de sécurité

1. **Utilisez AWS IAM Roles** en production plutôt que des clés statiques
2. **Activez AWS CloudTrail** pour auditer les actions
3. **Configurez des budgets AWS** pour surveiller les coûts
4. **Utilisez AWS Organizations** pour gérer plusieurs comptes
5. **Activez la rotation des clés** régulièrement

#### 8. Ressources utiles pour débuter

- **[AWS Free Tier](https://aws.amazon.com/free/)** : Services gratuits pendant 12 mois
- **[AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)** : Bonnes pratiques
- **[AWS Cost Calculator](https://calculator.aws/)** : Estimation des coûts
- **[AWS Documentation](https://docs.aws.amazon.com/)** : Documentation officielle

#### 9. Estimation des coûts

Ce projet utilise les services suivants. Coûts approximatifs (région eu-west-1) :

**IaaS :**
- EC2 instances (t3.micro) : ~$8-15/mois
- Application Load Balancer : ~$16/mois
- CloudFront : Variables selon usage

**PaaS :**
- Lambda : Gratuit jusqu'à 1M requêtes/mois
- DynamoDB : Gratuit jusqu'à 25GB
- API Gateway : $3.50/million requêtes
- S3 : ~$0.023/GB/mois

💡 **Conseil :** Commencez avec le Free Tier et surveillez vos coûts via AWS Budgets.

### Déploiement IaaS

1. **Configuration de l'infrastructure :**
   ```bash
   cd IAAS/terraform
   cp terraform.tfvars.example terraform.tfvars
   # Éditer terraform.tfvars avec vos valeurs
   terraform init
   terraform plan
   terraform apply
   ```

2. **Configuration de l'application :**
   Voir le guide détaillé : [IAAS/sample-app/README.md](./IAAS/sample-app/README.md)

### Déploiement PaaS

⚠️ **Important :** Suivez impérativement les étapes de pré-déploiement dans [PAAS/README.md](./PAAS/README.md)

1. **Préparation des artefacts :**
   ```bash
   cd PAAS
   # Suivre les instructions du README PaaS pour :
   # - Zipper les fonctions Lambda
   # - Build des assets S3
   # - Création des layers Lambda
   ```

2. **Déploiement :**
   ```bash
   terraform init
   terraform workspace select <environment> # dev2, dev4, etc.
   terraform plan
   terraform apply
   ```

## 📚 Documentation Détaillée

### Guides Spécifiques
- **[Application Laravel (IaaS)](./IAAS/sample-app/README.md)** : Configuration, base de données, déploiement
- **[Prérequis PaaS](./PAAS/README.md)** : Étapes obligatoires avant déploiement

### Configuration Ansible
- **Configuration** : `IAAS/ansible/`
- **Inventaire** : Copier `inventory.ini.example` vers `inventory.ini`
- **CloudWatch Agent** : Configuration dans `config/cloudwatch/`

## 🔧 Gestion des Environnements

Le projet supporte plusieurs environnements via Terraform workspaces :
- `dev2` 
- `dev4`

```bash
# Lister les workspaces
terraform workspace list

# Changer d'environnement  
terraform workspace select dev2
```

## 📁 Structure des Fichiers Ignorés

Le projet utilise un `.gitignore` unifié qui exclut :
- Variables locales Terraform (`terraform.tfvars`)
- États et plans Terraform locaux
- Dépendances Node.js (`node_modules`)
- Fichiers de build et artifacts
- Fichiers temporaires Laravel

## 🛠️ Commandes Utiles

### Terraform
```bash
# Initialisation
terraform init

# Planification
terraform plan

# Application
terraform apply

# Destruction
terraform destroy
```

### Application Laravel
```bash
cd IAAS/sample-app

# Installation des dépendances
composer install

# Migration de la base
php artisan migrate

# Seed des données
php artisan db:seed
```

**Note :** Ce projet nécessite une configuration AWS appropriée et des droits suffisants pour créer les ressources définies dans les modules Terraform." 
