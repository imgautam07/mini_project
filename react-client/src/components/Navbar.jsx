// src/components/Navbar.jsx
import React, { useState } from "react";
import { FaInstagram, FaSearch, FaUserCircle } from "react-icons/fa";

const Navbar = () => {
  const [dropdownOpen, setDropdownOpen] = useState(false);

  // Toggle the dropdown visibility
  const toggleDropdown = () => {
    setDropdownOpen((prevState) => !prevState);
  };

  return (
    <div className="flex items-center justify-between bg-white p-8 shadow-md">
      <div className="flex items-center space-x-4">
        <FaInstagram className="text-3xl text-pink-500 cursor-pointer" />
        <input
          type="text"
          placeholder="Search"
          className="border rounded-full p-2 w-full"
        />
      </div>

      <div className="relative">
        <FaUserCircle
          className="text-3xl cursor-pointer"
          onClick={toggleDropdown}
        />

        {/* Dropdown Menu */}
        {dropdownOpen && (
          <div className="absolute right-0 mt-2 w-48 bg-white border border-gray-300 rounded-md shadow-lg z-10">
            <ul className="space-y-2 py-2">
              <li
                className="px-4 py-2 text-gray-800 cursor-pointer hover:bg-gray-200"
                onClick={() => alert("Edit Profile")}
              >
                Edit Profile
              </li>
              <li
                className="px-4 py-2 text-gray-800 cursor-pointer hover:bg-gray-200"
                onClick={() => alert("Logout")}
              >
                Logout
              </li>
            </ul>
          </div>
        )}
      </div>
    </div>
  );
};

export default Navbar;
