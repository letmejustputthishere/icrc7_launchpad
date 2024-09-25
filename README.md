# ICRC-7 Launchpad

## Quickstart

> [!IMPORTANT]
> Make sure that [Node.js](https://nodejs.org/en/) `>= 20`, [mops](https://docs.mops.one/quick-start) `>=1.0.0` and [`dfx`](https://internetcomputer.org/docs/current/references/dfxvm/) `>= 0.23.0` are installed on your system.

> [!WARNING]
> Make sure to have a `identity.pem` at the root of the project. Provide the account identifier of this identity in the `init_args` of the `dfx.json` file for the ledger and cmc canister deployments.

```bash
dfx start --clean --background # Run dfx in the background
npm run setup # Install packages, deploy canisters, and generate type bindings

npm start # Start the development server

# in a new terminal run
npm run upload-canisters # upload the wasm files for the icrc7 ledger and asset canister to the launchpad canister
npm run create-collections # create a number of dummy collections on the launchpad
```

## 🛠️ Technology Stack

- [Vite](https://vitejs.dev/): high-performance tooling for front-end web development
- [SvelteKit](https://kit.svelte.dev/): a component-based UI library
- [TypeScript](https://www.typescriptlang.org/): JavaScript extended with syntax for types
- [Sass](https://sass-lang.com/): an extended syntax for CSS stylesheets
- [Prettier](https://prettier.io/): code formatting for a wide range of supported languages
- [Motoko](https://github.com/dfinity/motoko#readme): a safe and simple programming language for the Internet Computer
- [Mops](https://mops.one): an on-chain community package manager for Motoko
- [mo-dev](https://github.com/dfinity/motoko-dev-server#readme): a live reload development server for Motoko
- [eslint](https://eslint.org/): a static code analysis tool used in software development for identifying problematic patterns or code that doesn't adhere to certain style guidelines in JavaScript and TypeScript
- [Internet Identity](https://github.com/dfinity/internet-identity/tree/main): a decentralized identity provider for the Internet Computer
- [pic.js](https://github.com/hadronous/pic-js): an Internet Computer Protocol canister testing library for TypeScript and JavaScript

## 🧪 Testing

You can run `npm run test` to run unit tests using [`mops test`](https://docs.mops.one/cli/mops-test) and end-to-end tests using [`pic.js`](https://hadronous.github.io/pic-js/).

## 📚 Documentation

- [Vite developer docs](https://vitejs.dev/guide/)
- [SvelteKit quick start guide](https://learn.svelte.dev/tutorial/introducing-sveltekit)
- [Internet Computer docs](https://internetcomputer.org/docs/current/developer-docs/ic-overview)
- [`dfx.json` reference schema](https://internetcomputer.org/docs/current/references/dfx-json-reference/)
- [Motoko developer docs](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/motoko/)
- [Mops usage instructions](https://j4mwm-bqaaa-aaaam-qajbq-cai.ic0.app/#/docs/install)
- [Internet Identity docs](https://internetcomputer.org/docs/current/developer-docs/integrations/internet-identity/overview)
- [pic-js](https://hadronous.github.io/pic-js/)

## 💡 Tips and Tricks

- Customize your project's code style by editing the `.prettierrc` file and then running `npm run format`.
- Reduce the latency of update calls by passing the `--emulator` flag to `dfx start`.
- Install a Motoko package by running `mops add <package-name>`. Here is a [list of available packages](https://mops.one/).
- Split your frontend and backend console output by running `npm run frontend` and `npm run backend` in separate terminals.
