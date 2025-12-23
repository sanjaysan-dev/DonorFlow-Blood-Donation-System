<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DonorFlow - Home</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 text-gray-800 font-sans min-h-screen flex flex-col">

    <nav class="bg-red-600 text-white shadow-md p-4 sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="flex items-center gap-2 text-2xl font-bold cursor-pointer">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="white" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                DonorFlow
            </a>
            <div class="hidden md:flex space-x-6 font-medium items-center">
                <a href="index.jsp" class="hover:text-red-200 transition">Home</a>
                <a href="login.jsp" class="hover:text-red-200 transition">Login</a>
                <a href="register.jsp" class="bg-white text-red-600 px-4 py-2 rounded-full hover:bg-red-100 transition shadow-sm">Join Us</a>
            </div>
        </div>
    </nav>

    <main class="flex-grow">
        <div class="flex flex-col items-center justify-center min-h-[80vh] bg-gradient-to-br from-red-50 to-white px-4 text-center">
            <h1 class="text-5xl md:text-6xl font-extrabold text-red-700 mb-6 tracking-tight">
                Donate Blood, <span class="text-gray-800">Save Life.</span>
            </h1>
            <p class="text-xl text-gray-600 mb-8 max-w-2xl">
                The bridge between donors and patients. Register now to manage blood requests and donations efficiently.
            </p>
            <div class="flex flex-col md:flex-row gap-4">
                <a href="login.jsp" class="bg-red-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-red-700 transition shadow-lg transform hover:-translate-y-1">
                    Login to Request
                </a>
                <a href="register.jsp" class="bg-white border-2 border-red-600 text-red-600 px-8 py-3 rounded-lg font-semibold hover:bg-red-50 transition shadow-lg transform hover:-translate-y-1">
                    Register as Donor
                </a>
            </div>

            <div class="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8 w-full max-w-4xl">
                <div class="p-6 bg-white shadow-md rounded-xl border border-gray-100">
                    <h3 class="text-4xl font-bold text-gray-800">Secure</h3>
                    <p class="text-red-500 font-medium">Verified Process</p>
                </div>
                <div class="p-6 bg-white shadow-md rounded-xl border border-gray-100">
                    <h3 class="text-4xl font-bold text-gray-800">Fast</h3>
                    <p class="text-red-500 font-medium">Instant Approval System</p>
                </div>
                <div class="p-6 bg-white shadow-md rounded-xl border border-gray-100">
                    <h3 class="text-4xl font-bold text-gray-800">Digital</h3>
                    <p class="text-red-500 font-medium">Get E-Pass PDF</p>
                </div>
            </div>
        </div>
    </main>

    <footer class="bg-gray-900 text-white p-6 mt-auto text-center text-gray-400">
        &copy; 2025 DonorFlow.
    </footer>
</body>
</html>