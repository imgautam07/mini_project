// src/App.js
import React, { useState } from 'react';
import Signup from './components/signup';
import Signin from './components/signin';
import './App.css';
function App() {
  const [isSignup, setIsSignup] = useState(true);

  const toggleAuthPage = () => {
    setIsSignup(!isSignup);
  };

  return (
    <div>
      {isSignup ? (
        <Signup onToggle={toggleAuthPage} />
      ) : (
        <Signin onToggle={toggleAuthPage} />
      )}
    </div>
  );
}

export default App;
