use dioxus::prelude::*;

#[component]
pub fn Hero() -> Element {
    let mut contact_number = use_signal(String::new);

    let clean_contact_number = move || {
        contact_number()
            .trim()
            .replace("+", "")
            .replace(" ", "")
            .replace("-", "")
    };

    let whatsapp_chat_url = move || {
        format!("https://wa.me/{}", clean_contact_number())
    };

    let telegram_chat_url = move || {
        format!("https://t.me/+{}", clean_contact_number())
    };

    let signal_chat_url = move || {
        format!("https://signal.me/#p/+{}", clean_contact_number())
    };

    rsx! {
        div {
            class: "flex flex-col gap-6",

            label {
                class: "text-cat-rosewater",
                for: "contact_number",
                "Enter contact number with country code: "
            }



            input {
                class: "h-12 w-full rounded-xl border border-cat-surface0 bg-cat-surface0 px-4 text-base text-cat-text placeholder:text-cat-subtext0 placeholder:italic focus:placeholder-transparent focus:border-cat-green focus:outline-none",
                id: "contact_number",
                name: "contact_number",
                r#type: "text",
                inputmode: "tel",
                autocomplete: "tel",
                placeholder: "918149833469",
                value: "{contact_number}",
                oninput: move |evt| {
                    contact_number.set(evt.value());
                }
            }

            div {
                class: "flex gap-4",
                a {
                    href: "{whatsapp_chat_url()}",
                    target: "_blank",
                    class: "inline-block px-4 py-2 bg-cat-green text-cat-base rounded",
                    "WhatsApp"
                }
                a {
                    href: "{telegram_chat_url()}",
                    target: "_blank",
                    class: "inline-block px-4 py-2 bg-cat-green text-cat-base rounded",
                    "Telegram"
                }
                a {
                    href: "{signal_chat_url()}",
                    target: "_blank",
                    class: "inline-block px-4 py-2 bg-cat-green text-cat-base rounded",
                    "Signal"
                }
            }

        }
    }
}
