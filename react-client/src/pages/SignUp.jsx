// src/pages/SignUp.jsx
// eslint-disable-next-line no-unused-vars
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function SignUp() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleSignUp = (e) => {
    e.preventDefault();
    // Perform sign-up logic here
    alert("Account created! Please log in.");
    navigate("/");
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <form onSubmit={handleSignUp} className="p-8 bg-white rounded shadow-md w-80">
        <h2 className="text-2xl font-bold mb-6 text-center">Sign Up</h2>
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
        <button type="submit" className="w-full py-2 bg-green-500 text-white font-bold rounded">
          Sign Up
        </button>
        <p className="mt-4 text-center">
          Already have an account? <a href="/" className="text-blue-500">Sign In</a>
        </p>
      </form>
    </div>
  );
}

export default SignUp;
