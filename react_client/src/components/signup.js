// src/components/signup.js
import React from 'react';
import {
  Container,
  TextField,
  Button,
  Typography,
  Box,
  IconButton,
  InputAdornment,
} from '@mui/material';
import { Visibility, VisibilityOff, Google, Apple } from '@mui/icons-material';
import './signup.css'; 

export default function Signup({ onToggle }) {
  const [showPassword, setShowPassword] = React.useState(false);
  const handleTogglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  return (
    <Container
      maxWidth="xs"
      className="signup-container" 
      sx={{
        mt: 4,
        textAlign: 'center',
        borderRadius: 2,
        p: 4,
      }}
    >
      <Typography variant="h5" gutterBottom sx={{ color: '#fff' }}>
        Sign Up
      </Typography>
      <Box component="form" noValidate>
        <TextField
          fullWidth
          label="Email Address"
          type="email"
          variant="outlined"
          sx={{ mb: 2, input: { color: '#fff' }, label: { color: '#aaa' } }}
        />
        <TextField
          fullWidth
          label="Password"
          type={showPassword ? 'text' : 'password'}
          variant="outlined"
          sx={{ mb: 2, input: { color: '#fff' }, label: { color: '#aaa' } }}
          InputProps={{
            endAdornment: (
              <InputAdornment position="end">
                <IconButton onClick={handleTogglePasswordVisibility}>
                  {showPassword ? <VisibilityOff /> : <Visibility />}
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
        <TextField
          fullWidth
          label="Repeat Password"
          type={showPassword ? 'text' : 'password'}
          variant="outlined"
          sx={{ mb: 3, input: { color: '#fff' }, label: { color: '#aaa' } }}
          InputProps={{
            endAdornment: (
              <InputAdornment position="end">
                <IconButton onClick={handleTogglePasswordVisibility}>
                  {showPassword ? <VisibilityOff /> : <Visibility />}
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
        <Button
          variant="contained"
          fullWidth
          sx={{
            background: 'linear-gradient(to right, #FF8C00, #FF00FF)',
            mb: 2,
            color: '#fff',
            '&:hover': {
              background: 'linear-gradient(to right, #FF00FF, #FF8C00)',
            },
          }}
        >
          Sign Up
        </Button>
        <Typography variant="body2" sx={{ color: '#fff', mb: 1 }}>
          or
        </Typography>
        <Button
          startIcon={<Google />}
          fullWidth
          variant="outlined"
          sx={{ color: '#fff', borderColor: '#aaa', mb: 1 }}
        >
          Sign Up with Google
        </Button>
        <Button
          startIcon={<Apple />}
          fullWidth
          variant="outlined"
          sx={{ color: '#fff', borderColor: '#aaa', mb: 2 }}
        >
          Sign Up with Apple
        </Button>
        <Typography variant="body2" sx={{ color: '#fff' }}>
          Have an account?{' '}
          <a href="#" style={{ color: '#f093fb' }} onClick={onToggle}>
            Sign In
          </a>
        </Typography>
      </Box>
    </Container>
  );
}
