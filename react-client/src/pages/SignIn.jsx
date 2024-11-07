// src/pages/SignIn.jsx
// eslint-disable-next-line no-unused-vars
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

// eslint-disable-next-line react/prop-types
function SignIn({ setIsAuthenticated }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleSignIn = (e) => {
    e.preventDefault();
    // Set isAuthenticated to true to simulate a successful login
    setIsAuthenticated(true);
    navigate("/dashboard");
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <form onSubmit={handleSignIn} className="p-8 bg-white rounded shadow-md w-80">
        <h2 className="text-2xl font-bold mb-6 text-center">Sign In</h2>
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full px-4 py-2 mb-4 border rounded"
          required
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full px-4 py-2 mb-4 border rounded"
          required
        />
        <button type="submit" className="w-full py-2 bg-blue-500 text-white font-bold rounded">
          Sign In
        </button>
        <p className="mt-4 text-center">
          Dont have an account? <a href="/signup" className="text-blue-500">Sign Up</a>
        </p>
      </form>
    </div>
  );
}

export default SignIn;
