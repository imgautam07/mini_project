import React from "react";
import { FaHome, FaSearch, FaHeart, FaUserAlt } from "react-icons/fa";
import { Link } from "react-router-dom";

const Sidebar = () => {
  return (
    <div className="hidden lg:flex flex-col items-center w-20 h-[calc(100vh-64px)] bg-gray-900 text-white py-8 space-y-6">
      <Link to="/dashboard">
        <FaHome className="text-2xl cursor-pointer" />
      </Link>
      <Link to="/search">
        <FaSearch className="text-2xl cursor-pointer" />
      </Link>
      <Link to="/notifications">
        <FaHeart className="text-2xl cursor-pointer" />
      </Link>
      <Link to="/profile">
        <FaUserAlt className="text-2xl cursor-pointer" />
      </Link>
    </div>
  );
};

export default Sidebar;
