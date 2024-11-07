import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Dashboard from "./pages/Dashboard";
import Search from "./pages/Search";
import Notifications from "./pages/Notifications";
import Profile from "./pages/Profile";
import Sidebar from "./components/Sidebar";
import Navbar from "./components/Navbar";

const App = () => {
  return (
    <Router>
      {/* Navbar at the top */}
      <Navbar />
      <div className="flex">
        {/* Sidebar below Navbar */}
        <Sidebar />
        <div className="flex-1 p-4">
          <Routes>
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/search" element={<Search />} />
            <Route path="/notifications" element={<Notifications />} />
            <Route path="/profile" element={<Profile />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
};

export default App;
