workspace "Takodu Platform" "Agentic SaaS for MYPE appointment scheduling in Lima Metropolitana." {

    model {
        # Users
        owner    = person "MYPE Owner"    "Owner or administrator of a MYPE business. Manages services, staff, and occupation reports."
        employer = person "MYPE Employee" "Frontline MYPE worker (receptionist, stylist, therapist). Checks the daily agenda and receives reschedule alerts."

        # Central System
        takodu = softwareSystem "Takodu Platform" "Agentic SaaS that automates appointment scheduling for MYPEs via a conversational AI agent, eliminating double-booking and no-shows." {
            gremory = container "Gremory" "Browser-based app for MYPE owners and employees to manage services, staff, and the daily agenda." "Next.js 16, TypeScript" "Container,Web,Next.js"
            haimiya = container "Haimiya"   "REST API that handles business logic, integrates external providers, and orchestrates persistence."                       "Java 25, Spring Boot 3" "Container,Backend,Spring" {
                iam           = component "IAM"             "Identity, authentication, and session management. Supports Google OAuth and email sign-in."             "Spring Boot, Java 25" "Component,iam"
                assistant     = component "Assistant"       "Conversational booking agent backed by DeepSeek. Caches availability, appointments, and services."   "Spring Boot, Java 25" "Component,assistant"
                scheduling    = component "Scheduling"      "Appointment scheduling: availability, bookings, and lifecycle states."                                    "Spring Boot, Java 25" "Component,scheduling"
                workforce     = component "Workforce"       "Staff, roles, permissions, and Redis-backed invitation tokens."                                           "Spring Boot, Java 25" "Component,workforce"
                business      = component "Business"        "MYPE tenant management: organizations and establishments."                                                "Spring Boot, Java 25" "Component,business"
                catalog       = component "Catalog"         "Services catalog: offerings, durations, and pricing."                                                     "Spring Boot, Java 25" "Component,catalog"
                crm           = component "CRM"            "Customer records with Decolecta-backed identity lookup."                                                   "Spring Boot, Java 25" "Component,crm"
                profiles      = component "Profiles"        "Owner and employee profile records."                                                                      "Spring Boot, Java 25" "Component,profiles"
                billing       = component "Billing"         "Subscriptions, invoices, and Stripe payments."                                                            "Spring Boot, Java 25" "Component,billing"
                media         = component "Media"           "Media asset gateway that delegates processing to Openinary. No own database schema."                    "Spring Boot, Java 25" "Component,media"
                notifications = component "Notifications"  "Email (SES) and push (Gorush) dispatcher."                                                                  "Spring Boot, Java 25" "Component,notifications"
                audit         = component "Audit"           "Appends audit events received from other contexts."                                                       "Spring Boot, Java 25" "Component,audit"
                analytics     = component "Analytics"       "Reports and KPIs. Reads operational data via dedicated read repositories and gates plan access through billing ACL." "Spring Boot, Java 25" "Component,analytics"
            }
            db     = container "Database"         "Relational store for users, businesses, services, staff, appointments, and bookings."                        "PostgreSQL"             "Container,PostgreSQL"
            cache  = container "Cache"            "In-memory cache for sessions, locks, and hot read paths."                                                  "Redis"                  "Container,Redis"
        }

        # External Systems
        deepseek  = softwareSystem "DeepSeek Platform"     "LLM provider powering the RAG-based conversational booking agent."                       "External,AI,DeepSeek"
        decoleta  = softwareSystem "Decoleta API"          "Third-party API consumed to enrich MYPE operations data."                                "External,API,Decoleta"
        openinary = softwareSystem "Openinary"             "Media service used to process and optimize assets uploaded by MYPEs."                   "External,API,Openinary"
        ses       = softwareSystem "Amazon SES"            "Transactional email service for confirmations, reminders, and notifications."          "External,Email,Amazon"
        gorush    = softwareSystem "Gorush"                "Push notification gateway for real-time schedule alerts to employee devices."          "External,Push,Gorush"
        google    = softwareSystem "Google OAuth 2"        "Identity provider for MYPE owners and employees to sign in with Google accounts."        "External,Google"
        stripe    = softwareSystem "Stripe"                "Payment platform for MYPE subscription billing and one-off charges."                    "External,Stripe"

        # User Relationships (person -> container; system-level inferred for the context view)
        owner    -> gremory "Manages subscription, services, staff, and occupation reports"
        employer -> gremory "Checks the daily agenda and receives reschedule alerts"

        # Container Relationships (system-level relationships are inferred by Structurizr)
        gremory -> haimiya "Calls business endpoints over HTTPS" "HTTPS/REST"

        # Component-to-data-store relationships
        # Redis users: iam (sessions/tokens), assistant (@Cacheable on ACL facades), workforce (invitation tokens)
        # PostgreSQL users: 12 of 13 contexts; media has no own schema (delegates everything to Openinary)
        iam           -> cache  "Stores sessions, tokens, and rate-limit counters"           "RESP/Redis"
        assistant     -> cache  "Caches availability, appointments, and services"            "RESP/Redis"
        workforce     -> cache  "Indexes invitation tokens"                                  "RESP/Redis"

        iam           -> db     "Reads and writes users, roles, and sessions"                "JDBC/PostgreSQL"
        assistant     -> db     "Persists conversation history and resolved intents"          "JDBC/PostgreSQL"
        scheduling    -> db     "Reads and writes appointments and availability"             "JDBC/PostgreSQL"
        workforce     -> db     "Reads and writes staff, roles, and permissions"             "JDBC/PostgreSQL"
        business      -> db     "Reads and writes organizations and establishments"          "JDBC/PostgreSQL"
        catalog       -> db     "Reads and writes services and pricing"                       "JDBC/PostgreSQL"
        crm           -> db     "Reads and writes customers"                                 "JDBC/PostgreSQL"
        profiles      -> db     "Reads and writes owner and employee profiles"                "JDBC/PostgreSQL"
        billing       -> db     "Reads and writes subscriptions and invoices"                 "JDBC/PostgreSQL"
        notifications -> db     "Reads and writes notification templates and logs"            "JDBC/PostgreSQL"
        audit         -> db     "Appends audit events"                                        "JDBC/PostgreSQL"
        analytics     -> db     "Reads operational data via dedicated read repositories"      "JDBC/PostgreSQL"

        # Cross-context ACL relationships (derived from each context's `import com.takodu.<other>.interfaces.acl` / `application.acl`)
        iam           -> notifications "Sends auth-related notifications via ACL"              "ACL"
        assistant     -> business      "Resolves tenant and establishment data via ACL"       "ACL"
        assistant     -> catalog       "Resolves service catalog data via ACL"                "ACL"
        assistant     -> crm           "Resolves customer identity and records via ACL"      "ACL"
        assistant     -> scheduling    "Resolves availability and appointment data via ACL"   "ACL"
        assistant     -> workforce     "Resolves staff and permission data via ACL"           "ACL"
        analytics     -> billing       "Gates plan access via ACL"                             "ACL"
        audit         -> business      "Resolves tenant context for audit records via ACL"    "ACL"
        audit         -> workforce     "Resolves staff context for audit records via ACL"     "ACL"
        billing       -> business      "Resolves tenant and establishment data via ACL"       "ACL"
        billing       -> iam           "Resolves user identity and roles via ACL"             "ACL"
        business      -> billing       "Resolves plan limits and subscription status via ACL" "ACL"
        business      -> iam           "Resolves user identity and roles via ACL"             "ACL"
        business      -> media         "Resolves media asset references via ACL"              "ACL"
        business      -> workforce     "Resolves staff and permission data via ACL"           "ACL"
        catalog       -> workforce     "Resolves staff permissions via ACL"                    "ACL"
        crm           -> business      "Resolves tenant and establishment data via ACL"       "ACL"
        crm           -> workforce     "Resolves staff data via ACL"                          "ACL"
        notifications -> iam           "Resolves user contact info via ACL"                    "ACL"
        notifications -> workforce     "Resolves staff data via ACL"                          "ACL"
        profiles      -> media         "Resolves media asset references via ACL"              "ACL"
        scheduling    -> workforce     "Resolves staff availability via ACL"                  "ACL"
        workforce     -> billing       "Resolves plan limits via ACL"                          "ACL"
        workforce     -> business      "Resolves tenant data via ACL"                         "ACL"
        workforce     -> iam           "Resolves user identity and roles via ACL"             "ACL"
        workforce     -> notifications "Resolves notification preferences via ACL"             "ACL"
        workforce     -> profiles      "Resolves profile data via ACL"                        "ACL"

        # Component-to-external-system relationships (verified against actual outbound HTTP clients / SDKs)
        iam           -> google    "Exchanges authorization codes for Google OAuth tokens"          "HTTPS/OAuth 2"
        assistant     -> deepseek  "Sends chat completion requests to the LLM"                       "HTTPS/REST"
        billing       -> stripe    "Creates checkout sessions and processes subscription charges"    "HTTPS/REST"
        crm           -> decoleta  "Looks up customer identity by document number"                   "HTTPS/REST"
        media         -> openinary "Uploads and transforms media assets"                             "HTTPS/REST"
        notifications -> ses       "Sends transactional email through Amazon SESv2"                 "HTTPS/REST"
        notifications -> gorush    "Dispatches push notifications to employee devices"               "HTTPS/REST"
    }

    views {
        systemContext takodu "TakoduContext" {
            description "System Context diagram for the Takodu Platform"
            include *
            autoLayout lr
        }

        container takodu "TakoduContainers" {
            description "Container diagram for the Takodu Platform"
            include *
            autoLayout lr
        }

        component haimiya "TakoduComponents" {
            description "Component diagram for Haimiya API Platform"
            include *
            autoLayout lr
        }

        styles {
            element "Element" {
                color #ffffff
                background #2563eb
            }
            element "Person" {
                shape person
                background #374151
                color #ffffff
            }
            element "DeepSeek" {
                background #1e3a8a
            }
            element "API" {
                background #7c3aed
            }
            element "Decoleta" {
                background #7c3aed
            }
            element "Openinary" {
                background #0d9488
            }
            element "Email" {
                background #000000
            }
            element "Amazon" {
                background #ea580c
            }
            element "Push" {
                background #14b8a6
            }
            element "Gorush" {
                background #14b8a6
            }
            element "Google" {
                background #4285f4
            }
            element "Stripe" {
                background #635bff
            }
            element "External" {
                border dashed
                stroke #6b7280
                strokeWidth 2
            }
            element "Web" {
                background #0ea5e9
            }
            element "Backend" {
                background #2563eb
            }
            element "Next.js" {
                background #000000
            }
            element "Spring" {
                background #6db33f
            }
            element "PostgreSQL" {
                shape cylinder
                background #336791
            }
            element "Redis" {
                shape cylinder
                background #dc382d
            }
        }
    }
}
