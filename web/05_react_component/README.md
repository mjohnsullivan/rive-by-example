# React Component

This is a simple example demonsatrating how to create a React component that plays a Rive animation. For simplicity and clarity, all the code is contained in ```index.html```. This page compiles JSX in the browser and should not be used for production.

It should be straightforward to reuse/adapt the ```RiveAnimation``` component and the ```loadRiveModule```/```loadRive``` functions in your React app.

Note that not all web bundlers play nicely with Wasm; if you run into difficulties, check your bundler's documentation. If you're using webpack and get an error like ```Module not found: Can't resolve 'fs'```, try adding ```"node": { "fs": "empty" }``` to your config (*webpack.config.js*).