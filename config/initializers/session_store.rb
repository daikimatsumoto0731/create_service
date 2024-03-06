Rails.application.config.session_store :cookie_store, key: '_vegetable_services_session', secure: Rails.env.production?, httponly: true, same_site: :strict
