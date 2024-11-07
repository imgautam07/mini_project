import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Dashboard from "./pages/Dashboard";
import SignIn from "./pages/SignIn";
import SignUp from "./pages/SignUp";
import Sidebar from "./components/Sidebar";
import Navbar from "./components/Navbar";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/signin" element={<SignIn />} />
        <Route path="/signup" element={<SignUp />} />
        
        {/* For Dashboard, include Navbar and Sidebar */}
        <Route
          path="/dashboard"
          element={
            <>
              <Navbar />
              <div className="flex">
                <Sidebar />
                <div className="flex-1 p-4">
                  <Dashboard />
                </div>
              </div>
            </>
          }
        />
      </Routes>
    </Router>
  );
};

export default App;
