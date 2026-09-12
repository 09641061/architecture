workspace "Takodu Platform" "Agentic SaaS for MYPE appointment scheduling in Lima Metropolitana." {

    model {
        # Users
        owner    = person "MYPE Owner"    "Owner or administrator of a MYPE service business. Configures services, staff, and monitors occupation."
        employer = person "MYPE Employee" "Frontline worker (receptionist, stylist, therapist, assistant). Consults the daily agenda and receives reschedule alerts."

        # Central System
        takodu = softwareSystem "Takodu Platform" "Agentic SaaS that automates appointment scheduling for MYPEs via a conversational AI agent, eliminating double-booking and no-shows."

        # External Systems
        deepseek  = softwareSystem "DeepSeek Platform"     "LLM provider powering the RAG-based conversational booking agent."                       "External,AI,DeepSeek"
        decoleta  = softwareSystem "Decoleta API"          "Third-party API consumed to enrich MYPE operations data."                                "External,API,Decoleta"
        openinary = softwareSystem "Openinary"             "Media service used to process and optimize assets uploaded by MYPEs."                   "External,API,Openinary"
        ses       = softwareSystem "Amazon SES"            "Transactional email service for confirmations, reminders, and notifications."          "External,Email,Amazon"
        gorush    = softwareSystem "Gorush"                "Push notification gateway for real-time schedule alerts to employee devices."          "External,Push,Gorush"
        google    = softwareSystem "Google OAuth 2"        "Identity provider for MYPE owners and employees to sign in with Google accounts."        "External,Google"
        stripe    = softwareSystem "Stripe"                "Payment platform for MYPE subscription billing and one-off charges."                    "External,Stripe"

        # User Relationships
        owner    -> takodu "Manages subscription, services, staff, and occupation reports"
        employer -> takodu "Consults the daily agenda and receives reschedule notifications"

        # System Relationships
        takodu -> deepseek  "Routes natural-language queries to the LLM to resolve availability"            "HTTPS/REST"
        takodu -> decoleta  "Enriches MYPE operations data through a third-party API"                         "HTTPS/REST"
        takodu -> openinary "Processes and optimizes media assets uploaded by MYPEs"                          "HTTPS/REST"
        takodu -> ses       "Sends booking confirmations, reminders, and operational notifications"         "HTTPS/REST"
        takodu -> gorush    "Delivers real-time schedule alerts to employee devices"                        "HTTPS/REST"
        takodu -> google    "Authenticates MYPE users through Google accounts"                               "HTTPS/OAuth 2"
        takodu -> stripe    "Charges MYPE subscription fees and one-off payments"                            "HTTPS/REST"
    }

    views {
        systemContext takodu "TakoduContext" {
            description "System Context diagram for the Takodu Platform"
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
        }
    }
}
