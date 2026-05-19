use crate::Route;
use dioxus::prelude::*;

/// The Layout component that will be rendered on all pages of our app since every page is under the layout.
///
///
/// This layout component wraps the UI of [Route::Home] and [Route::Blog] in a common layout. The contents of the Home and Blog
/// routes will be rendered under the outlet inside this component
#[component]
pub fn Layout() -> Element {
    rsx! {
        document::Meta {
            name: "viewport",
            content: "width=device-width, initial-scale=1.0, interactive-widget=resizes-content"
        }
        div {
            class: "flex min-h-dvh flex-col bg-cat-crust text-cat-text",
            id: "layout",

            header {
                class: "sticky top-0 z-10 flex min-h-16 shrink-0 items-center border-b border-cat-surface0 bg-cat-mantle px-5 shadow-lg shadow-cat-surface0",
                Link {
                    to: Route::Home {},
                    "NoSave Chat"
                }
            },

            main {
                class: "mx-auto flex min-h-0 w-full max-w-md flex-1 flex-col gap-6 overflow-y-auto px-5 py-6",
                Outlet::<Route> {}
            }
        }

        // The `Outlet` component is used to render the next component inside the layout. In this case, it will render either
        // the [`Home`] or [`Blog`] component depending on the current route.
    }
}
