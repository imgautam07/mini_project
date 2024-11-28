import React from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import Dashboard from "./pages/Dashboard";
import Search from "./pages/Search";
import Notifications from "./pages/Notifications";
import Profile from "./pages/Profile";
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
        
        {/* Redirect to dashboard directly after login */}
        <Route
          path="/dashboard"
          element={
            <div className="flex">
              <Sidebar />
              <div className="flex-1">
                <Navbar />
                <Dashboard />
              </div>
            </div>
          }
        />

        <Route path="/search" element={<Search />} />
        <Route path="/notifications" element={<Notifications />} />
        <Route path="/profile" element={<Profile />} />
      </Routes>
    </Router>
  );
};

export default App;
